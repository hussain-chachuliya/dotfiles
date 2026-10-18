#!/bin/sh
# Thunar "Copy Contents" analog — cat files to system clipboard, portable:
# macOS pbcopy, Wayland wl-copy, X11 xclip/xsel

to_clipboard() {
	if command -v pbcopy >/dev/null 2>&1; then
		pbcopy
	elif command -v wl-copy >/dev/null 2>&1; then
		wl-copy
	elif command -v xclip >/dev/null 2>&1; then
		xclip -selection clipboard
	elif command -v xsel >/dev/null 2>&1; then
		xsel --clipboard --input
	else
		return 1
	fi
}

if [ "$#" -eq 0 ]; then
	printf 'Nothing selected\n'
else
	if cat "$@" | to_clipboard; then
		printf 'Copied contents of %s file(s) to clipboard\n' "$#"
	else
		printf 'No clipboard tool found (pbcopy/wl-copy/xclip/xsel)\n' >&2
	fi
fi

printf 'Press enter to close… '
read _
