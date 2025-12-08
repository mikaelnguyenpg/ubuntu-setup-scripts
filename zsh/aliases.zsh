# Zsh aliases and custom functions for user eagle
# Managed by Home-Manager on Ubuntu 24.04

# nix: nix-shell -p <appname>

alias cl=clear

# Eza (modern ls replacement)
alias ls="eza --icons"
alias la="eza --icons -a"
alias ll="eza -l --icons --git"
alias lla="eza -l --icons --git -a"
alias lt="eza --tree --level=1 --icons --git -I node_modules"
alias ltl="lt --long"

# Navigation aliases
alias cd="z"
alias ..="cd .. && eza --icons"
alias ...="cd ../.. && eza --icons"
alias ....="cd ../../.. && eza --icons"
alias .....="cd ../../../.. && eza --icons"
alias ......="cd ../../../../.. && eza --icons"

# alias ls="lsd"
# alias ll='ls -l'
# alias la='ls -a'
# alias lla='ls -la'
# alias lt='ls --tree -I node_modules'

alias bsl="~/.local/bin/BrowserStackLocal --key gJjMRxK6KtMx5o9XbJsb"

alias sourcea="source ~/.config/zsh/aliases.zsh"
alias sourcez="source ~/.zshrc"

