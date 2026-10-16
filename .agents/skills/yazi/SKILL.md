---
name: yazi
description: Instructions and guidelines for managing the dotfiles/configuration for Yazi terminal file manager.
---

# Yazi Dotfiles Skill

A project‑level skill for managing [yazi][] configuration as dotfiles.

## Overview

This directory `~/.config/yazi` holds the complete yazi setup:

- `yazi.toml` – main configuration (linemode, plugins, preview, tasks, opener)
- `init.lua` – lua scripts for custom linemodes, headers, git signs, etc.
- `keymap.toml` – manager‑level keybindings
- `theme.toml` – colorscheme & icons
- `package.toml` – plugin dependencies (yazi plugin format)
- `flavors/` – optional flavor definitions
- `plugins/` – additional plugin configs

## Installation

1. **Install yazi** – follow the official guide: <https://yazi-rs.github.io/docs/installation>
   - macOS: `brew install yazi`
   - Linux: cargo or binary from GitHub
   - Windows: via Scoop or chocolatey

2. **Clone / symlink this dotfile repo** into `~/.config/yazi`:

   ```bash
   git clone https://github.com/yourself/dotconfig-yazi.git ~/.config/yazi
   # or simply ln -s /path/to/this/repo ~/.config/yazi
   ```

3. **Launch yazi** – it will load `yazi.toml`, `init.lua`, etc. automatically.

## Configuration

| File           | Purpose                                                                    |
| -------------- | -------------------------------------------------------------------------- |
| `yazi.toml`    | Global settings: linemode, sorting, preview size, tasks, opener rules      |
| `init.lua`     | Lua scripts for custom behavior (git signs, header hiding, linemode logic) |
| `keymap.toml`  | Manager‑level keybindings (`on = "l"` etc.)                                |
| `theme.toml`   | Colorscheme, flavor, icon overrides                                        |
| `package.toml` | yazi plugin dependencies (e.g. `git`, `smart-enter`, `piper`)              |
| `flavors/`     | Alternative UI flavors (e.g. `vscode-dark-modern`)                         |

Edit any file in the repo (verify with `realpath ~/.config/yazi/init.lua` — here it resolves into the dotfiles repo, so one edit covers both). `yazi.toml` hot-reloads; `init.lua` needs a yazi restart.

## Plugins

Plugins are defined in `package.toml` using the yazi plugin format:

```toml
[[plugin.deps]]
use = "yazi-rs/plugins:git"
rev = "6cf1f43"
hash = "347cc6b..."
```

To add a new plugin:

1. Append a `[[plugin.deps]]` block with the plugin `use` string, optional `rev` and `hash`.
2. Ensure the plugin’s runtime files are in `~/.local/share/yazi/plugins/` (handled by yazi's package manager).
3. Reload yazi.

See the existing `package.toml` for examples (`git`, `smart-enter`, `piper`, `mediainfo`, `ouch`, etc.).

## Customisation

- **Linemode** – `size_and_mtime` in `init.lua` shows permissions, size, date, and git branch. Re‑define or extend in `init.lua`.
- **Date/time format** – keep one `fmt_time` helper in `init.lua` (`os.date("%d-%b-%Y %I:%M%p", t)`) and override `Linemode:mtime()` + `Linemode:btime()` so every time display matches.
- **Combined default view** – define `Linemode:size_mtime()` as `Linemode.size(self)` plus `fmt_time(...)` (reuses the async dir-size logic); set `[mgr] linemode = "size_mtime"`, `sort_by = "mtime"`, `sort_reverse = true` for newest-first.
- **Sort keys also switch linemode** – stock `,M` runs `sort mtime --reverse=yes` plus `linemode mtime`; overriding the default linemode does not change that. Rebind in `keymap.toml` if `,M` must keep the combined view.
- **Keymap** – Add or re‑map keys in `keymap.toml`. Example: `on = "A"` creates a new directory.
- **Theme** – Change `use = "vscode-dark-modern"` in `theme.toml` or craft your own flavor.
- **Previewers** – Add/remove previewers in `yazi.toml` under `[plugin.prepend_previewers]`.

## Updating yazi

When a new yazi version is available:

1. Upgrade via your package manager (`brew update && brew upgrade yazi`, `cargo update yazi`, etc.).
2. Check `package.toml` for plugin `rev`/`hash` values; update them if you want to track newer plugin versions.
3. Review `yazi.toml` for any syntax changes between versions (the config is generally backward‑compatible).

## Backup / Restore

- The whole `~/.config/yazi` directory is the backup.
- To restore, simply re‑symlink or `git clone` the repo into `~/.config/yazi`.
- Optionally tar‑archive: `tar czf yazi-dotfiles.tar.gz ~/.config/yazi`.

## Related skills

- `yazi-lua-api` – v26.x plugin API pitfalls (preview_widget singular, delegation, image display)
- `yazi-plugins` – vetted plugins, `ya pkg` workflow, version-range checks
- `yazi-keymap` – additive keymap authoring, TOML traps, free-key checks
- `yazi-portable-scripts` – POSIX sh portable across macOS and Linux

## References

- Official documentation: <https://yazi-rs.github.io/docs/installation>
- Plugin system: <https://yazi-rs.github.io/docs/plugins>
- Lua API: <https://yazi-rs.github.io/docs/ lua-api>

---

_Generated as a dedicated skill for managing yazi dotfiles at `~/.config/yazi`._

