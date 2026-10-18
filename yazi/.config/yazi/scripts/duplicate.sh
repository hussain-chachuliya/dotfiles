#!/bin/sh
# Thunar "Duplicate" analog — copy with unique name: "name copy.ext", "name copy 2.ext" …

for f in "$@"; do
	[ -e "$f" ] || continue
	dir=$(dirname "$f")
	base=$(basename "$f")

	case "$base" in
		.*)
			# dotfile like .bashrc -> treat whole name as stem
			stem="$base"
			ext=""
			;;
		*.*)
			stem=${base%.*}
			ext=.${base##*.}
			;;
		*)
			stem="$base"
			ext=""
			;;
	esac

	candidate="${stem} copy${ext}"
	i=2
	while [ -e "$dir/$candidate" ]; do
		candidate="${stem} copy ${i}${ext}"
		i=$((i + 1))
	done

	if cp -R "$f" "$dir/$candidate"; then
		printf 'Duplicated -> %s\n' "$dir/$candidate"
	else
		printf 'Failed to duplicate %s\n' "$f" >&2
	fi
done

printf 'Press enter to close… '
read _
