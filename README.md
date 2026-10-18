# Dotfiles

Managed with GNU Stow.

## Usage

```sh
./stow.sh
```

Interactively select packages (all selected by default). Stows selected packages into `$HOME`.

## Notes

- Conflicting existing files are backed up to `backup/<timestamp>/`.
- Existing symlinks are unstowed before stowing.