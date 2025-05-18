# Zsh functions for managing packages (Nala, Nix, Snap, Flatpak)
# Managed by Home-Manager for user eagle on Ubuntu 24.04

# Helper: Check if command exists
_command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Helper: Color output
# _green() { print -P "%F{green}$1%f"; }
# _red() { print -P "%F{red}$1%f"; }
_green() { echo -e "\033[32m$1\033[0m"; }
_red() { echo -e "\033[31m$1\033[0m"; }

# --- List Installed Packages ---
nala_list() {
  if ! _command_exists nala; then
    echo $(_red "Nala not installed")
    return 1
  fi
  echo $(_green "=== Nala (APT) Installed Packages ===")
  # nala list --installed | grep -v "Listing..." | sort
  nala list --installed | grep -v "Listing..."
  echo
}

nix_list() {
  if ! _command_exists nix; then
    echo $(_red "Nix not installed")
    return 1
  fi
  echo $(_green "=== Nix (Home-Manager) Installed Packages ===")
  home-manager packages | xargs -n1 basename | sort || echo "No packages"
  # nix profile list | awk '{print $2}' | grep -v '^$' | sort || echo "No packages"
  echo
}

snap_list() {
  if ! _command_exists snap; then
    echo $(_red "Snap not installed")
    return 1
  fi
  echo $(_green "=== Snap Installed Packages ===")
  snap list | awk 'NR>1 {print $1 " (v" $2 ")"}' | sort || echo "No snaps"
  echo
}

flatpak_list() {
  if ! _command_exists flatpak; then
    echo $(_red "Flatpak not installed")
    return 1
  fi
  echo $(_green "=== Flatpak Installed Apps ===")
  flatpak list --app --columns=name,application,version | sort
  echo $(_green "=== Flatpak Runtimes ===")
  flatpak list --runtime --columns=name,application,version | sort
  echo
}

pkg_list() {
  echo $(_green "===== Installed Packages Across Managers =====")
  nala_list
  nix_list
  snap_list
  flatpak_list
}

# --- Search Available Packages ---
nala_search() {
  if [[ -z "$1" ]]; then
    echo "Usage: nala_search <query>"
    return 1
  fi
  if ! _command_exists nala; then
    echo $(_red "Nala not installed")
    return 1
  fi
  echo $(_green "=== Nala (APT) Search for '$1' ===")
  nala search "$1" | grep -v "Searching..." | sort || echo "No results"
  echo
}

nix_search() {
  if [[ -z "$1" ]]; then
    echo "Usage: nix_search <query>"
    return 1
  fi
  if ! _command_exists nix; then
    echo $(_red "Nix not installed")
    return 1
  fi
  echo $(_green "=== Nixpkgs Search for '$1' ===")
  nix search nixpkgs "#$1" --no-cache --json | jq -r '.[] | "\(.name) - \(.description)"' | sort || echo "No results"
  echo
}

snap_search() {
  if [[ -z "$1" ]]; then
    echo "Usage: snap_search <query>"
    return 1
  fi
  if ! _command_exists snap; then
    echo $(_red "Snap not installed")
    return 1
  fi
  echo $(_green "=== Snap Search for '$1' ===")
  snap find "$1" | awk 'NR>1 {print $1 " (v" $2 ")"}' | sort || echo "No results"
  echo
}

flatpak_search() {
  if [[ -z "$1" ]]; then
    echo "Usage: flatpak_search <query>"
    return 1
  fi
  if ! _command_exists flatpak; then
    echo $(_red "Flatpak not installed")
    return 1
  fi
  echo $(_green "=== Flatpak (Flathub) Search for '$1' ===")
  flatpak search "$1" --columns=name,application,version,description | sort
  echo
}

pkg_search() {
  if [[ -z "$1" ]]; then
    echo "Usage: pkg_search <query>"
    return 1
  fi
  echo $(_green "===== Search for '$1' Across Managers =====")
  nala_search "$1"
  nix_search "$1"
  snap_search "$1"
  flatpak_search "$1"
}

# --- Install Packages ---
nala_install() {
  if [[ -z "$1" ]]; then
    echo "Usage: nala_install <package>"
    return 1
  fi
  if ! _command_exists nala; then
    echo $(_red "Nala not installed")
    return 1
  fi
  echo "Installing APT package '$1'..."
  sudo nala install -y "$1" && echo $(_green "Installed '$1'")
}

nix_install() {
  if [[ -z "$1" ]]; then
    echo "Usage: nix_install <package>"
    return 1
  fi
  if ! _command_exists nix; then
    echo $(_red "Nix not installed")
    return 1
  fi
  echo "To install '$1' with Home-Manager, add to home.nix:"
  echo "  home.packages = with pkgs; [ $1 ];"
  echo "Then run: home-manager switch"
  echo "For ad-hoc install: nix profile install nixpkgs#$1"
}

nix_update() {
  if ! _command_exists home-manager; then
    echo $(_red "Home-manager not installed")
    return 1
  fi
  echo "Installing Home-manager packages"
  home-manager switch --show-trace && echo $(_green "Installed")
}

snap_install() {
  if [[ -z "$1" ]]; then
    echo "Usage: snap_install <snap>"
    return 1
  fi
  if ! _command_exists snap; then
    echo $(_red "Snap not installed")
    return 1
  fi
  echo "Installing Snap package '$1'..."
  sudo snap install "$1" && echo $(_green "Installed '$1'")
}

flatpak_install() {
  if [[ -z "$1" ]]; then
    echo "Usage: flatpak_install <app-id>"
    return 1
  fi
  if ! _command_exists flatpak; then
    echo $(_red "Flatpak not installed")
    return 1
  fi
  echo "Installing Flatpak app '$1'..."
  flatpak install -y flathub "$1" && echo $(_green "Installed '$1'")
}

pkg_install() {
  if [[ -z "$1" ]]; then
    echo "Usage: pkg_install <package>"
    return 1
  fi
  echo $(_green "===== Attempting to Install '$1' =====")
  echo "Trying Nala..."
  if nala search "$1" | grep -q "^$1 "; then
    nala_install "$1"
    return
  fi
  echo "Trying Nix..."
  if nix search nixpkgs "#$1" --no-cache --json | jq -e ".\"$1\"" >/dev/null; then
    nix_install "$1"
    return
  fi
  echo "Trying Snap..."
  if snap find "$1" | grep -q "^$1 "; then
    snap_install "$1"
    return
  fi
  echo "Trying Flatpak..."
  if flatpak search "$1" | grep -q "$1"; then
    flatpak_install "$1"
    return
  fi
  echo $(_red "Package '$1' not found in any manager")
}

# --- Remove Packages ---
nala_remove() {
  if [[ -z "$1" ]]; then
    echo "Usage: nala_remove <package>"
    return 1
  fi
  if ! _command_exists nala; then
    echo $(_red "Nala not installed")
    return 1
  fi
  echo "Removing APT package '$1'..."
  sudo nala remove -y "$1" && sudo nala autoremove -y && echo $(_green "Removed '$1'")
}

nix_remove() {
  if [[ -z "$1" ]]; then
    echo "Usage: nix_remove <package>"
    return 1
  fi
  if ! _command_exists nix; then
    echo $(_red "Nix not installed")
    return 1
  fi
  echo "Removing Nix package '$1'..."
  nix profile remove ".*$1.*" && nix-collect-garbage && echo $(_green "Removed '$1'")
  echo "Run 'home-manager switch' to update configuration"
}

nix_clean() {
  if ! _command_exists nix-collect-garbage; then
    echo $(_red "nix-collect-garbage not installed")
    return 1
  fi
  echo "Installing Home-manager packages"
  nix-collect-garbage -d && echo $(_green "Cleaned-up")
}

snap_remove() {
  if [[ -z "$1" ]]; then
    echo "Usage: snap_remove <snap>"
    return 1
  fi
  if ! _command_exists snap; then
    echo $(_red "Snap not installed")
    return 1
  fi
  echo "Removing Snap package '$1'..."
  sudo snap remove "$1" && echo $(_green "Removed '$1'")
}

flatpak_remove() {
  if [[ -z "$1" ]]; then
    echo "Usage: flatpak_remove <app-id>"
    return 1
  fi
  if ! _command_exists flatpak; then
    echo $(_red "Flatpak not installed")
    return 1
  fi
  echo "Removing Flatpak app '$1'..."
  flatpak uninstall -y "$1" && flatpak uninstall -y --unused && echo $(_green "Removed '$1'")
}

pkg_remove() {
  if [[ -z "$1" ]]; then
    echo "Usage: pkg_remove <package>"
    return 1
  fi
  echo $(_green "===== Attempting to Remove '$1' =====")
  echo "Trying Nala..."
  if dpkg -l | grep -q "$1"; then
    nala_remove "$1"
    return
  fi
  echo "Trying Nix..."
  if nix profile list | grep -q "$1"; then
    nix_remove "$1"
    return
  fi
  echo "Trying Snap..."
  if snap list | grep -q "$1"; then
    snap_remove "$1"
    return
  fi
  echo "Trying Flatpak..."
  if flatpak list | grep -q "$1"; then
    flatpak_remove "$1"
    return
  fi
  echo $(_red "Package '$1' not found in any manager")
}

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
