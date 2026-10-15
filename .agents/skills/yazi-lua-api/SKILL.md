---
name: yazi-lua-api
description: Yazi Lua plugin API pitfalls for v26.x — preview_widget singular, job fields, delegation, image display, verification commands.
---

# Yazi Lua API (v26.x)

## Previewer contract

- Render with `ya.preview_widget(job, widget)` — **SINGULAR**. The plural
  `ya.preview_widgets` does not exist in v26.x and throws
  `attempt to call a nil value (field "preview-widgets")`.
- Methods: `M:peek(job)`, `M:seek(job)`, `M:spot(job)`, `M:entry(job)`.
  Missing methods are simply never called — omit what you don't need.
- **Return from `peek` without rendering to fall through** to the next matching
  previewer. This is the standard toggle-off pattern.
- Text widgets: `ui.Text.parse(s):area(rect):wrap(ui.Wrap.YES)`.
- Only these are renderable: `Text Line Span List Table Bar Border Gauge Input`.
  There is **no image widget** — images go through `ya.image_show(path, area)`
  (direct terminal rendering, outside the widget system).

## Job fields (all safe to read)

`job.file.url`, `job.file.cha.is_dir`, `job.mime` (yes, mime is on the job —
use it for dispatch, not extension guessing), `job.skip`, `job.area`, `job.args`.

## Images + thumbnails

- `ya.image_show(path, area)` displays an image; `ya.file_cache(job)` gives a
  cache path; pair with a `preload()` that renders the thumbnail (ffmpeg).
- Reference: `boydaihungst/mediainfo.yazi` (stacked thumbnail + metadata),
  official `yazi-rs/plugins:piper` (canonical streaming previewer).

## Delegating to built-in previewers

Built-ins are requireable Lua modules (`"code"`, `"image"`, `"video"`, …):

```lua
local ok, mod = pcall(require, name)
if ok and type(mod.peek) == "function" then
  pcall(mod.peek, mod, shadow_job) -- shadow_job = { file=job.file, area=sub_rect, skip=job.skip or 0, args={} }
end
```

- Sub-areas: `ui.Rect { x=area.x, y=area.y, w=area.w, h=top_h }` is
  constructible (keep values exact integers — bad rects can crash yazi).
- Seek forwarding: `require("code"):seek(job)` (piper.yazi does exactly this).
- Wrap every delegate call in `pcall` with a text fallback — a throwing
  delegate breaks preview for every file it matches.
- Reference: `peterfication/mux.yazi` (full delegation pattern).

## init.lua is not a plugin context

- `ya.sync()` and `ui.render()` throw `must be called in a plugin` from
  `init.lua` (including inside `Linemode:*` overrides) — never call them there.
- `ya.async()` and `ya.emit()` DO work from `init.lua`.
- To re-render after async work completes, emit `ya.emit("peek", {})`
  instead of calling `ui.render()`.

## Sync → async boundary

- Render-scoped `File`/`Url` userdata is destructed by the time a `ya.async`
  body runs (`userdata has been destructed`). Pass only plain strings across
  the boundary (`local key = tostring(file.url)`), rebuild inside the task
  (`Url(key)`).
- Guard with a `pending` table so each key spawns at most one task; cache
  results (per-session cache is the lazy default — note staleness in a
  `ponytail:` comment).

## Async recursive dir-size linemode (verified pattern)

```lua
local cache, pending = {}, {}
function Linemode:size()
  local size = self._file:size()
  if size then return ya.readable_size(size) end
  if not self._file.cha.is_dir then return "" end
  local key = tostring(self._file.url) -- string only, userdata dies async
  if cache[key] then return cache[key] end
  if not pending[key] then
    pending[key] = true
    ya.async(function()
      local ok, total = pcall(function()
        local it = assert(fs.calc_size(Url(key)))
        local sum = 0
        while true do
          local n = it:recv()
          if not n then break end
          sum = sum + n
        end
        return sum
      end)
      pending[key] = nil
      cache[key] = ok and ya.readable_size(total) or "?"
      ya.emit("peek", {}) -- re-render; ui.render() is unavailable here
    end)
  end
  return "…" -- placeholder while measuring
end
```

- Built-in `linemode = "size"` shows file sizes by default, but directory
  sizes are only evaluated when `sort_by = "size"` — the override above is
  what makes folder totals appear unconditionally.

## Verify before shipping

- API renamed across versions — confirm against YOUR binary, not memory:
  `strings $(which yazi) | grep -oE "preview_widgets?|image_show|file_cache" | sort -u`
- Syntax: `luajit -b plugin/main.lua /tmp/x.luac`
- Docs are versioned (`yazi-rs.github.io/docs/...` has a version picker) —
  match them to `yazi --version`.
- `ya.emit("peek", {})` forces a re-peek (use after toggles AND as the
async-completion re-render from `init.lua`, where `ui.render()` is unavailable);
  `ya.notify { title=..., content=..., timeout=... }` for feedback.
- Headless end-to-end test: drive yazi from Python `pty.fork()` with an
explicit `TIOCSWINSZ` (yazi aborts without terminal dimensions), point
`YAZI_CONFIG_HOME` at a sandbox dir, quit with `q` after N seconds.
Trace execution via `io.open("/tmp/x.txt", "a")` file logging from Lua —
the yazi.log location is unreliable across platforms.
