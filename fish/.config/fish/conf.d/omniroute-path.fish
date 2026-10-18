# Make user-local binaries (node, npm, npx, omniroute) available in fish
if test -d "$HOME/.local/bin"
    fish_add_path --prepend "$HOME/.local/bin"
end