#!/bin/sh
# Thunar "Checksums" analog — portable (macOS + Linux)

sha256() {
	if command -v sha256sum >/dev/null 2>&1; then
		sha256sum "$1" | cut -d' ' -f1
	else
		shasum -a 256 "$1" | cut -d' ' -f1
	fi
}

md5() {
	if command -v md5sum >/dev/null 2>&1; then
		md5sum "$1" | cut -d' ' -f1
	elif command -v md5 >/dev/null 2>&1; then
		md5 -q "$1"
	fi
}

for f in "$@"; do
	[ -e "$f" ] || continue
	printf '───── %s\n' "$(basename "$f")"
	printf 'sha256: %s\n' "$(sha256 "$f")"
	printf 'md5:    %s\n' "$(md5 "$f")"
	printf '\n'
done

printf 'Press enter to close… '
read _
