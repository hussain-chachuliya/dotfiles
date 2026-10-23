# Fish aliases
alias y yazi
if type -q eza
    alias ls 'eza --icons'
else if type -q exa
    alias ls 'exa --icons'
end
