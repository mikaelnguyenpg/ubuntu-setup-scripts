# Zsh aliases and custom functions for user eagle
# Managed by Home-Manager on Ubuntu 24.04

# Navigation aliases
alias cd="z"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Eza (modern ls replacement)
alias ls="eza --icons"
alias lsa="eza --icons -a"
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=3 --icons --git"

# --- Utilities ---
# Change directory and list
cx() { cd "$@" && lsa; }

# Fuzzy find directory and change
fcd() { cd "$(find . -type d -not -path '*/.*' | fzf)" && l; }

# Fuzzy find file and copy path to clipboard
f() { echo "$(find . -type f -not -path '*/.*' | fzf)" | xclip -selection clipboard; }

# Fuzzy find file and open in nvim
fv() { nvim "$(find . -type f -not -path '*/.*' | fzf)"; }
# Fuzzy find file and open in helix
fh() { hx "$(find . -type f -not -path '*/.*' | fzf)"; }
