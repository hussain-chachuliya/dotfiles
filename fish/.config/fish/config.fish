source /usr/share/cachyos-fish-config/cachyos-config.fish

# Pi
fish_add_path "/home/hussain/.pi/agent/bin"

set -gx EDITOR helix
set -gx GTK_USE_PORTAL 1

# zoxide
zoxide init fish | source

# Aliases
source $__fish_config_dir/aliases.fish
