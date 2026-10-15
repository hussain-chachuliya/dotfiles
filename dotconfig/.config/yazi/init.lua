-- yazi init.lua
-- Set up bookmarks (Thunar Places) using yamb

local sep = package.config:sub(1, 1)
local home = os.getenv("HOME")

local function bm(tag, path, key)
  return { tag = tag, path = home .. sep .. path .. sep, key = key }
end

local bookmarks = {
  bm("Home", "", "h"),
  bm("Desktop", "Desktop", "D"),
  bm("Documents", "Documents", "c"),
  bm("Downloads", "Downloads", "d"),
  bm("Music", "Music", "m"),
  bm("Pictures", "Pictures", "p"),
  bm("Videos", "Videos", "v"),
}

require("yamb"):setup {
  bookmarks = bookmarks,
  jump_notify = true,
  cli = "fzf",
}

require("zoxide"):setup({
  update_db = true,
})

-- Show recursive directory size in the middle pane (async, non-blocking).
-- Files use the built-in size; dirs are measured with fs.calc_size() in a
-- ya.async task so scrolling never stalls, then cached for the session.
-- Only a plain string crosses the sync->async boundary: render-scoped
-- File/Url userdata is destructed by the time the task runs, so the Url is
-- rebuilt inside the task. A "peek" emit re-renders once a size lands.
-- (No ya.sync/ui.render here: those require a plugin context, init.lua has none.)
-- ponytail: per-session cache, no expiry; totals can go stale if dir
-- contents change. Restart yazi to refresh.
local dir_size_cache, dir_size_pending = {}, {}

function Linemode:size()
  local size = self._file:size()
  if size then
    return ya.readable_size(size)
  end
  local cha = self._file.cha
  if not cha or not cha.is_dir then
    return ""
  end
  local key = tostring(self._file.url)
  if dir_size_cache[key] then
    return dir_size_cache[key]
  end
  if not dir_size_pending[key] then
    dir_size_pending[key] = true
    ya.async(function()
      local ok, total = pcall(function()
        local it = assert(fs.calc_size(Url(key)))
        local sum = 0
        while true do
          local n = it:recv()
          if not n then
            break
          end
          sum = sum + n
        end
        return sum
      end)
      dir_size_pending[key] = nil
      -- ponytail: "?" on error (e.g. permission denied), no retry loop
      dir_size_cache[key] = ok and ya.readable_size(total) or "?"
      ya.emit("peek", {})
    end)
  end
  return "…"
end
