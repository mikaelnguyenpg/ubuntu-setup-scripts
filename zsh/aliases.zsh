# Zsh aliases and custom functions for user eagle
# Managed by Home-Manager on Ubuntu 24.04

# nix: nix-shell -p <appname>

alias cl=clear

# Navigation aliases
alias cd="z"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Eza (modern ls replacement)
alias ls="eza --icons"
alias la="eza --icons -a"
alias ll="eza -l --icons --git"
alias lla="eza -l --icons --git -a"
alias lt="eza --tree --level=1 --icons --git -I node_modules"
alias ltl="lt --long"

# alias ls="lsd"
# alias ll='ls -l'
# alias la='ls -a'
# alias lla='ls -la'
# alias lt='ls --tree -I node_modules'

alias sourcea="source ~/.config/zsh/aliases.zsh"
alias sourcez="source ~/.zshrc"

nneovide() { neovide "$@" > /dev/null 2>&1 &; }
nghostty() { ghostty "$@" > /dev/null 2>&1 &; }
nnotepad() { notepadqq "$@" > /dev/null 2>&1 &; }

# --- Utilities ---
# Change directory and list
cx() { cd "$@" && la; }

# Fuzzy find directory and change
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && ll; }

# Fuzzy find file and copy path to clipboard
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | xclip -selection clipboard; }

# Fuzzy find file and open in nvim
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)"; }
# Fuzzy find file and open in helix
fh() { hx "$(find . -type f -not -path '*/.*' | fzf)"; }
# Fuzzy find file and open in bat
fb() { bat "$(find . -type f -not -path '*/.*' | fzf)"; }

# Function to set local Git user email and name
# Usage: git_set_user <email> <name>
git_set_user() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: git_set_user <email> <name>"
    return 1
  fi

  git config --local user.email "$1"
  git config --local user.name "$2"
  echo "Set local Git user to email: $1, name: $2"
}
