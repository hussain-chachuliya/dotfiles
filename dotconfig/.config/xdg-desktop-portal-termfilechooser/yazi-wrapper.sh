#!/usr/bin/env bash

# Arguments passed by xdg-desktop-portal-termfilechooser:
# $1 = multiple (1/0)
# $2 = directory (1/0)
# $3 = path to output selected files/folders
# $4 = initial directory/file path

out="$3"
path="$4"

# Open terminal running Yazi with chooser output writing enabled
kitty --name "yazi-filechooser" -e yazi "$path" --chooser-file="$out"
