source /usr/share/cachyos-fish-config/cachyos-config.fish

# Pi
fish_add_path "/home/hussain/.pi/agent/bin"

set -gx PATH $PATH /opt/homebrew/bin
set -gx EDITOR nvim
set -gx GTK_USE_PORTAL 1
set -gx XDG_CONFIG_HOME ~/.config

# zoxide
zoxide init fish | source

# Aliases
source $__fish_config_dir/aliases.fish
