---
name: yazi-portable-scripts
description: Portable POSIX sh for yazi shell actions — GNU/BSD stat, checksums, clipboard fallback chains. macOS + Linux safe.
---

# Portable Shell Scripts (macOS + Linux)

Yazi `shell --block` actions run on whatever machine the dotfiles land on.
These three incompatibilities break silently across OSes — handle all of them.

## Detection patterns

```sh
# stat: GNU (Linux) vs BSD (macOS)
if stat --version >/dev/null 2>&1; then
  perms=$(stat -c '%A' "$f"); owner=$(stat -c '%U' "$f")   # GNU
else
  perms=$(stat -f '%Sp' "$f"); owner=$(stat -f '%Su' "$f") # BSD
fi
# GNU %w (birth time) prints "-" when unsupported — fall back to %y (mtime).

# checksums: prefer GNU, fall back to BSD/macOS
if command -v sha256sum >/dev/null 2>&1; then sha256sum "$f" | cut -d' ' -f1
else shasum -a 256 "$f" | cut -d' ' -f1; fi
if command -v md5sum >/dev/null 2>&1; then md5sum "$f" | cut -d' ' -f1
elif command -v md5 >/dev/null 2>&1; then md5 -q "$f"; fi

# clipboard: macOS -> Wayland -> X11 (function, so missing tools just skip)
to_clipboard() {
  if command -v pbcopy >/dev/null 2>&1; then pbcopy
  elif command -v wl-copy >/dev/null 2>&1; then wl-copy
  elif command -v xclip >/dev/null 2>&1; then xclip -selection clipboard
  elif command -v xsel >/dev/null 2>&1; then xsel --clipboard --input
  else return 1; fi
}
```

Safe everywhere without detection: `file -b`, `du -sh`, `dirname`/`basename`,
`cp -R`, `cut`. Dotfiles need a `case` guard (`.bashrc` has no extension):
`case "$base" in .*) stem="$base"; ext="";; *.*) stem=${base%.*}; ext=.${base##*.};; *) ...`.

## Rules

- POSIX `sh` only (no `[[ ]]`, no `${var:0:1}`), `sh -n` must pass, `chmod +x`.
- Guard every file with `[ -e "$f" ] || continue`, quote `"$@"`.
- End `--block` scripts with a `read` pause.
- Smoke-test directly (`script.sh file < /dev/null`) before testing inside yazi.
