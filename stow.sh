#!/usr/bin/env bash
set -euo pipefail

BOLD='\033[1m'; GREEN='\033[32m'; YELLOW='\033[33m'; CYAN='\033[36m'; RESET='\033[0m'

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET="${STOW_TARGET:-$HOME}"
BACKUP="$DOTFILES/backup/$(date +%Y%m%d_%H%M%S)"

if ! command -v stow >/dev/null 2>&1; then
    echo -e "${YELLOW}stow not found; install GNU stow${RESET}" >&2
    exit 1
fi
if ! command -v fzf >/dev/null 2>&1; then
    echo -e "${YELLOW}fzf not found${RESET}" >&2
    exit 1
fi

mapfile -t ALL < <(find "$DOTFILES" -mindepth 1 -maxdepth 1 -type d -printf '%f\n' | sort)
pkgs=()
for p in "${ALL[@]}"; do
    [[ "$p" == backup || "$p" == .* ]] && continue
    pkgs+=("$p")
done

selected=$(printf '%s\n' "${pkgs[@]}" | fzf --multi --bind 'load:select-all' --prompt='stow> ' --header='TAB: toggle, Enter: confirm') || { echo -e "${YELLOW}cancelled${RESET}"; exit 0; }
PACKAGES=()
while IFS= read -r p; do
    [[ -n "$p" ]] && PACKAGES+=("$p")
done <<< "$selected"

if [[ ${#PACKAGES[@]} -eq 0 ]]; then
    echo -e "${YELLOW}no packages selected${RESET}"
    exit 0
fi

# 1. Unstow all selected.
for pkg in "${PACKAGES[@]}"; do
    echo -e "\n${BOLD}${CYAN}▸ unstow:${RESET} $pkg"
    (cd "$DOTFILES" && stow -D -t "$TARGET" "$pkg") 2>/dev/null || true
done

# 2. Backup remaining conflicting files.
for pkg in "${PACKAGES[@]}"; do
    pkgdir="$DOTFILES/$pkg"
    while IFS= read -r -d '' f; do
        rel="${f#$pkgdir/}"
        dest="$TARGET/$rel"
        if [[ -e "$dest" && ! -L "$dest" ]]; then
            backup_path="$BACKUP/$pkg/$rel"
            mkdir -p "$(dirname "$backup_path")"
            mv "$dest" "$backup_path"
            echo -e "  ${YELLOW}backup:${RESET} $dest -> $backup_path"
            d="$(dirname "$dest")"
            while [[ "$d" != "$TARGET" && -d "$d" && -z "$(ls -A "$d")" ]]; do
                rmdir "$d" && d="$(dirname "$d")"
            done
        fi
    done < <(find "$pkgdir" -type f -print0)
    # back up any remaining files/folders at symlink locations
    for cand in "$TARGET/$pkg" "$TARGET/.config/$pkg"; do
        if [[ -e "$cand" && ! -L "$cand" ]]; then
            backup_path="$BACKUP/$pkg/_remaining_$(basename "$cand")"
            mkdir -p "$(dirname "$backup_path")"
            mv "$cand" "$backup_path"
            echo -e "  ${YELLOW}backup (remaining):${RESET} $cand -> $backup_path"
        fi
    done
done

# 3. Stow all selected.
for pkg in "${PACKAGES[@]}"; do
    echo -e "\n${BOLD}${GREEN}▸ stow:${RESET} $pkg"
    (cd "$DOTFILES" && stow -t "$TARGET" "$pkg")
    echo -e "  ${GREEN}✓ stowed:${RESET} $pkg"
done

if [[ -d "$BACKUP" ]]; then echo -e "\n${BOLD}${GREEN}done${RESET} (backup: $BACKUP)"; else echo -e "\n${BOLD}${GREEN}done${RESET} (no backup needed)"; fi