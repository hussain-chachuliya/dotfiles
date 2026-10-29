# Fish aliases
alias y yazi
alias l lazygit
if type -q eza
    alias ls 'eza --icons'
else if type -q exa
    alias ls 'exa --icons'
end
