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

# --- Apt ---
# List Installed Packages ---
apt_list() {
  if ! _command_exists apt; then
    echo $(_red "apt not installed")
    return 1
  fi
  echo $(_green "=== apt (APT) Installed Packages ===")
  # apt list --installed | grep -v "Listing..." | sort
  apt list --installed | grep -v "Listing..."
  echo
}

# Search Available Packages ---
apt_search() {
  if [[ -z "$1" ]]; then
    echo "Usage: apt_search <query>"
    return 1
  fi
  if ! _command_exists apt; then
    echo $(_red "apt not installed")
    return 1
  fi
  echo $(_green "=== apt (APT) Search for '$1' ===")
  # apt search "$1" | grep -v "Searching..." | sort || echo "No results"
  apt-cache search "$1" | grep -v "Searching..." | sort || echo "No results"
  echo
}

# Install Packages ---
apt_install() {
  if [[ -z "$1" ]]; then
    echo "Usage: apt_install <package>"
    return 1
  fi
  if ! _command_exists apt; then
    echo $(_red "apt not installed")
    return 1
  fi
  echo "Installing APT package '$1'..."
  sudo apt install -y "$1" && echo $(_green "Installed '$1'")
}

# Remove Packages ---
apt_remove() {
  if [[ -z "$1" ]]; then
    echo "Usage: apt_remove <package>"
    return 1
  fi
  if ! _command_exists apt; then
    echo $(_red "apt not installed")
    return 1
  fi
  echo "Removing APT package '$1'..."
  sudo apt remove -y "$1" && sudo apt autoremove -y && echo $(_green "Removed '$1'")
}

# --- Nala ---
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

# --- Nix ---
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
  nix search nixpkgs "#$1" --json | jq -r '.[] | "\(.name) \(.version) - \(.description)"' | sort || echo "No results"
  echo
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

# --- Flatpak ---
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

# --- Snap ---
snap_list() {
  if ! _command_exists snap; then
    echo $(_red "Snap not installed")
    return 1
  fi
  echo $(_green "=== Snap Installed Packages ===")
  snap list | awk 'NR>1 {print $1 " (v" $2 ")"}' | sort || echo "No snaps"
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

# --- pkg ---
pkg_list() {
  echo $(_green "===== Installed Packages Across Managers =====")
  nala_list
  nix_list
  snap_list
  flatpak_list
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

# --- Nix functions ---
# nneovide() { nixGL neovide "$@" > /dev/null 2>&1 &; }
# nghostty() { nixGL ghostty "$@" > /dev/null 2>&1 &; }
# nnotepad() { nixGL notepadqq "$@" > /dev/null 2>&1 &; }
# ncode() { code --no-sandbox "$@" > /dev/null 2>&1 &; }

# --- Other functions(Mine) ---
mbsl() {
  ~/.local/bin/BrowserStackLocal --key gJjMRxK6KtMx5o9XbJsb > /dev/null 2>&1 &
}
mcharles() { charles > /dev/null >2&1 &; }
mpritunl() { sudo systemctl restart pritunl-client.service && sudo systemctl status pritunl-client.service && pritunl-client-electron > /dev/null >2&1 &; }

# Function to set local Git user email and name
# Usage: git_set_user <email> <name>
set-git-user() {
  if [[ $# -ne 2 ]]; then
    echo "Usage: git_set_user <email> <name>"
    return 1
  fi

  git config --local user.email "$1"
  git config --local user.name "$2"
  echo "Set local Git user to email: $1, name: $2"
}

# Open directory from histories into Zelllij
zja() {
  local dir=$(zoxide query -l | fzf)
  if [ -n "$dir" ]; then
    cd "$dir"
    local name=$(basename "$dir")
    # Lệnh này sẽ: Nếu session tên 'name' tồn tại thì vào, 
    # nếu không sẽ tạo mới với tên đó.
    zellij attach -c "$name"
  fi
}

# Tự động ls mỗi khi thay đổi thư mục
chpwd() {
  eza --icons --group-directories-first
}

# Function giúp khởi động macOS Docker
#     docker run -it \
#       --name "$container_name" \
#       --device /dev/kvm \
#       -p 50922:10022 \
#       -v /tmp/.X11-unix:/tmp/.X11-unix \
#       -e "DISPLAY=${DISPLAY:-:0.0}" \
#       -e GENERATE_UNIQUE=true \
#       -e CPU='Haswell-noTSX' \
#       -e CPUID_FLAGS='kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on' \
#       -e MASTER_PLIST_URL='https://raw.githubusercontent.com/sickcodes/osx-serial-generator/master/config-custom-sonoma.plist' \
#       -e SHORTNAME=sequoia \
#       --device /dev/input/platform-i8042-serio-0-event-kbd \
#       -e EXTRA="-object input-linux,id=kbd1,evdev=/dev/input/eventX,grab_all=on,repeat=on"
#       sickcodes/docker-osx:latest
docker-create-mac() {
  local container_name="macos-sequoia"
  
  # Kiểm tra nếu đã tồn tại thì không tạo đè
  if [ "$(docker ps -aq -f name=^/${container_name}$)" ]; then
    echo "⚠️  Container '$container_name' đã tồn tại. Dùng 'docker-mac' để bật."
    return 1
  fi

  echo "✨ Đang khởi tạo máy Mac mới (Lần đầu cài đặt)..."
  echo "⌨️  Đang dò tìm bàn phím Asus TUF..."
  
  local KBD_PATH="/dev/input/by-path/platform-i8042-serio-0-event-kbd"
  local KBD_DEV=$(readlink -f "$KBD_PATH" 2>/dev/null)
  local EXTRA_CONFIG="-device qemu-xhci,id=usbcontroller -device usb-kbd,bus=usbcontroller.0"
  local DEV_ARG=""

  if [ -n "$KBD_DEV" ]; then
    echo "✅ Đã thấy bàn phím tại: $KBD_DEV"
    DEV_ARG="--device $KBD_DEV:$KBD_DEV"
    EXTRA_CONFIG+=",id=kbd1,evdev=$KBD_DEV,grab_all=on,repeat=on -object input-linux,id=kbd1,evdev=$KBD_DEV"
  fi

  # Cấp quyền X11 để hiện màn hình cài đặt
  xhost +local:docker > /dev/null 2>&1

  docker run -it \
    --name "$container_name" \
    --device /dev/kvm \
    $DEV_ARG \
    -p 50922:10022 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e "DISPLAY=${DISPLAY:-:0.0}" \
    -e GENERATE_UNIQUE=true \
    -e CPU='Haswell-noTSX' \
    -e CPUID_FLAGS='kvm=on,vendor=GenuineIntel,+invtsc,vmware-cpuid-freq=on' \
    -e MASTER_PLIST_URL='https://raw.githubusercontent.com/sickcodes/osx-serial-generator/master/config-custom-sonoma.plist' \
    -e SHORTNAME=sequoia \
    -e EXTRA="$EXTRA_CONFIG" \
    sickcodes/docker-osx:latest
}

docker-mac() {
    local container_name="macos-sequoia"
    local mode=$1
    
    # Kiểm tra container đã được tạo chưa
    if [ ! "$(docker ps -aq -f name=^/${container_name}$)" ]; then
        echo "❌ Chưa có máy ảo. Hãy chạy 'docker-create-mac' trước."
        return 1
    fi

    local is_running=$(docker inspect -f '{{.State.Running}}' "$container_name" 2>/dev/null)

    if [[ "$is_running" == "true" ]]; then
        echo "✅ Mac đang chạy rồi. Gõ 'ssh mac' để vào."
        return
    fi

    if [[ "$mode" == "-s" || "$mode" == "--ssh" ]]; then
        echo "☁️  Khởi động NGẦM (SSH mode)..."
        # Start không có -ai để chạy background
        docker start "$container_name"
        echo "👉 Đợi 1-2 phút rồi gõ: ssh MACNAME@localhost -p 50922 # MACNAME is name on Docker-OSX"
    else
        echo "🖥️  Khởi động GUI (Full mode)..."
        xhost +local:docker > /dev/null 2>&1
        # Start với -ai để hiện màn hình
        docker start -ai "$container_name"
    fi
}
