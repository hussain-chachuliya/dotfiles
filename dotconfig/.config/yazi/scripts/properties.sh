#!/bin/sh
# Thunar "Properties" analog for yazi — portable (macOS/BSD + Linux/GNU)

# Portable stat: print "<perms> <owner> <created> <modified>" (created may be "-")
stat_info() {
	if stat --version >/dev/null 2>&1; then
		# GNU coreutils (Linux)
		perms=$(stat -c '%A' "$1")
		owner=$(stat -c '%U' "$1")
		created=$(stat -c '%w' "$1" 2>/dev/null)
		[ "$created" = "-" ] || [ -z "$created" ] && created=$(stat -c '%y' "$1")
		modified=$(stat -c '%y' "$1")
	else
		# BSD (macOS)
		perms=$(stat -f '%Sp' "$1")
		owner=$(stat -f '%Su' "$1")
		created=$(stat -f '%SB' "$1")
		modified=$(stat -f '%Sm' "$1")
	fi
}

for f in "$@"; do
	[ -e "$f" ] || continue
	printf '───── %s\n' "$(basename "$f")"
	printf 'Name      : %s\n' "$(basename "$f")"
	printf 'Type      : %s\n' "$(file -b "$f" 2>/dev/null)"
	dir=$(cd "$(dirname "$f")" 2>/dev/null && pwd)
	printf 'Location  : %s\n' "$dir"
	printf 'Size      : %s\n' "$(du -sh "$f" 2>/dev/null | cut -f1)"
	stat_info "$f"
	printf 'Perms     : %s\n' "$perms"
	printf 'Owner     : %s\n' "$owner"
	printf 'Created   : %s\n' "$created"
	printf 'Modified  : %s\n' "$modified"
done

printf '\nPress enter to close… '
read _
