---
name: yazi-keymap
description: Yazi keymap.toml authoring — additive prepend pattern, TOML syntax traps, free-key checks, shell-arg conventions.
---

# Yazi keymap.toml

## Additive only

- All custom bindings go in `[[mgr.prepend_keymap]]` blocks with
  `on` / `run` / `desc`. Never copy or edit upstream defaults —
  prepend wins on conflict, so a colliding prefix silently shadows built-ins.
- Leave `[input]`, `[tasks]`, `[spot]`, `[pick]`, `[confirm]` layers alone
  unless the task explicitly targets them.

## TOML traps (all hit in practice)

- **One `key = value` per line.** `;` separators are INVALID TOML and fail
  `taplo check` with `expected new line` errors.
- Prefer double-quoted `run = "..."`; use single quotes only when the command
  contains no single quotes. For nested quoting, prefer moving the command
  into `scripts/*.sh` over triple-quote gymnastics.
- File args: `%s` = selected files (shell-quoted), `%h` = hovered,
  `%d` = dirname. End options with `--` so paths aren't parsed as flags:
  `run = 'shell --block -- "$YAZI_CONFIG_HOME/scripts/x.sh" %s'`
- `shell --block` takes over the screen until exit — end such scripts with a
  `read` pause or they flash and vanish.

## Free-key check

- Before binding, confirm the prefix is unbound in upstream
  `keymap-default.toml` (`sxyazi/yazi`, `shipped` branch,
  `yazi-config/preset/keymap-default.toml`). Chord prefixes (`u`, `e`,
  `c a …`) must have NO existing binding starting with them.
- Binary must support the schema: `strings $(which yazi) | grep -c prepend_keymap`
  (present since ~26.x; older yazi only has `[mgr] keymap`).

## Verify

1. `taplo check keymap.toml`
2. Launch yazi, press `~` — every new binding listed with its `desc`,
   and no existing binding missing.
3. Spot-check each binding with real files (multi-select included).
