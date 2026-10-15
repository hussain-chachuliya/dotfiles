---
name: yazi-plugins
description: Yazi plugin ecosystem — vetted plugins, ya pkg workflow, version-range checks, reference dotfiles. Adopt before building.
---

# Yazi Plugins — Adopt, Don't Build

## Install workflow

- `ya pkg add owner/repo` (repo itself ends in `.yazi`, e.g. `ya pkg add h-hg/yamb`).
  Writes locked `rev` + `hash` into `package.toml`. Verify with `ya pkg list`.
- **Local dir shadows pkg**: if `plugins/<name>.yazi/` exists locally,
  `ya pkg add` aborts for safety. Delete the local dir first (or `--discard`).
- Prefer `ya pkg` over `git clone` — locks survive `ya pkg install` on a new machine.

## Before adopting any plugin

Read its README for three things: (1) supported yazi version range
(e.g. `boydaihungst/mediainfo` documents `v26.5.6–v26.9.1` — APIs rename
between versions), (2) external binaries required, (3) required
`yazi.toml` (`prepend_previewers`/`prepend_preloaders`) and `init.lua`
(`setup()`) wiring. Then wire exactly that, nothing more.

## Vetted plugins (26.9.1, macOS + Linux)

- `h-hg/yamb` — persistent bookmarks, jump by key / fzf. Needs `fzf`.
  `init.lua`: `require("yamb"):setup { bookmarks = {...}, jump_notify = true }`.
- `KKV9/compress` — archive selected files. Needs `zip`/`tar`/etc. in PATH
  (falls back across tool families; `7z`/`rar` optional).
- `boydaihungst/mediainfo` — stacked preview (thumbnail on top, `mediainfo`
  metadata below) for `{audio,video,image}/*`. Needs `mediainfo` + `ffmpeg`.
  `yazi.toml` needs BOTH `prepend_preloaders` and `prepend_previewers` with
  matching args. Toggles: `plugin mediainfo -- toggle-metadata`
  (`toggle-preview`, `show-*`, `hide-*`, `reset` also exist).
- Official reference impls: `yazi-rs/plugins:piper` (pipe any shell cmd as
  previewer), `peterfication/mux.yazi` (previewer multiplexer/delegation).

## Reference dotfiles

- `nbaud/nico-yazi-config` — uses the same mediainfo setup; also demonstrates
  `piper` previewers (glow for markdown, ouch for archives), git fetchers,
  per-mime openers. Consult for patterns, but don't import its Linux-only
  openers (xviewer, flatpak VLC) onto macOS blindly.
