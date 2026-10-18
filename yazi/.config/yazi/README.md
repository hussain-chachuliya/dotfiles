# Yazi config with Thunar-parity features

## Quick cheat-sheet

| Feature | Keybinding | Description |
|---|---|---|
| **Sizes by default** | _(linemode)_ | Middle pane shows file sizes and recursive folder totals (async via `fs.calc_size`, cached per session; `…` while measuring, `?` on error) |
| **Compress** | `c a a` | Archive selected files (zip) |
| | `c a z` | Archive as zip |
| | `c a t` | Archive as tar |
| | `c a g` | Archive as tar.gz |
| | `c a x` | Archive as tar.xz |
| | `c a p` | Archive with password |
| | `c a l` | Set compression level |
| **Thunar extras** | `e p` | Properties dialog (name, type, size, perms, etc.) |
| | `e d` | Duplicate file(s) (creates `name copy`, `name copy 2`, …) |
| | `e h` | Checksums (sha256 + md5) |
| | `e m` | Toggle mediainfo metadata in preview (shown by default) |
| | `e c` | Copy file contents to clipboard (pbcopy) |

## Plugins installed

- `KKV9/compress` – archive files (zip, tar, 7z, etc.)
- `boydaihungst/mediainfo` – stacked preview for `{audio,video,image}/*`: thumbnail on top, `mediainfo` metadata below

## Installation notes

- All scripts are in `~/.config/yazi/scripts/` and are executable.
- The config lives in the dotfiles repo at `dotconfig/.config/yazi/` (symlinked from `~/.config/yazi`).
- The symlink is already in place; the directory was created during this setup.
- The `ya pkg` commands write to `package.toml` with version locks.

## Restoring / backup

- The entire configuration is in the dotfiles repo.
- To restore: `git clone <repo> ~/.config/yazi` (or symlink as before).
- To reinstall plugins: `ya pkg add KKV9/compress`

## Notes

- All keybinds are additive; they use `[[mgr.prepend_keymap]]` so they never override existing yazi defaults.
- The scripts are simple POSIX sh and should work on any Unix-like system.
- Media preview is **stacked**: thumbnail on top + `mediainfo` metadata below, for `{audio,video,image}/*` (via `boydaihungst/mediainfo`, same setup nico-yazi-config uses). Toggle metadata with `e m`. Requires `mediainfo` CLI + `ffmpeg` (both installed via Homebrew here; on Linux use your package manager).
- Unix-portable: scripts detect GNU vs BSD `stat`, `sha256sum`/`shasum`, `md5sum`/`md5`, and clipboard via `pbcopy` (macOS) → `wl-copy` (Wayland) → `xclip`/`xsel` (X11). Works on macOS and Linux with zero changes.