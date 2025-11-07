#!/bin/bash

# install-tools.sh
# Installs and configures tools on Ubuntu 24.04
# Usage: ./install-tools.sh [install|remove]
# check session type: `echo $XDG_SESSION_TYPE` # Wayland, X11
# install x11 session: `x11-apps`
# Ref: https://youtu.be/vLm2EHIaxOo?si=fn4AO2H4MCXV6rTK&t=552

set -e

# Constants
NIX_PROFILE="$HOME/.nix-profile/etc/profile.d/nix.sh"
CONFIG_DIR="$HOME/.config"
HM_DIR="$CONFIG_DIR/home-manager"
SAMPLE_DIR="$(dirname "$0")/../../home-manager"
APT_PKGS="curl build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev ibus-unikey ibus-chewing x11-apps ffmpeg openjdk-17-jdk ninja-build libgtk-3-dev"
QEMU_PKGS="qemu-system-x86 qemu-utils libvirt-daemon-system libvirt-clients bridge-utils virt-manager ovmf qemu-guest-agent"
SNAP_APPS=""
FLATPAK_APPS=""
PM=${PM:-apt}
[[ $PM == nala ]] && command -v nala >/dev/null && PM_CMD=nala || PM_CMD=apt
pm() { sudo $PM_CMD "$@"; }

# Logging
log() { printf "[INFO] %s\n" "$1"; }
error() { printf "[ERROR] %s\n" "$1" >&2; exit 1; }

# Check if command exists
command_exists() { command -v "$1" >/dev/null 2>&1; }

# Check if apt package is installed
is_apt_installed() { dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"; }

# Check if flatpak app is installed
is_flatpak_installed() { flatpak list | grep -q "$1"; }

# Check if snap package is installed
is_snap_installed() { snap list "$1" >/dev/null 2>&1; }

# Update and upgrade system
update_system() {
    log "Updating and upgrading system"
    if command_exists nala; then
        # sudo nala update && sudo nala upgrade -y
        log "nala NOT ready"
    else
        pm update && pm upgrade -y
    fi
}

# Install nala
install_nala() {
    if command_exists nala; then
        log "nala is already installed"
    else
        log "Installing nala"
        sudo apt install -y nala && sudo nala fetch --auto -y
    fi
}

# Install apt packages
install_apt_packages() {
    local pkgs="$1"
    for pkg in $pkgs; do
        if is_apt_installed "$pkg"; then
            log "$pkg is already installed"
        else
            log "Installing $pkg"
            pm install -y "$pkg"
        fi
    done
}

# Install Nvidia-drivers
install_nvidia_drivers() {
    lspci | grep -E "VGA|3D"
    ubuntu-drivers devices
    pm install -y nvidia-driver-580 # 1st way
    # sudo ubuntu-drivers autoinstall # 2nd way
}

# Install flatpak and apps
install_flatpak() {
    if command_exists flatpak; then
        log "flatpak is already installed"
    else
        log "Installing flatpak"
        pm install -y flatpak
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    for app in $FLATPAK_APPS; do
        if is_flatpak_installed "$app"; then
            log "$app is already installed"
        else
            log "Installing $app"
            flatpak install -y flathub "$app"
        fi
    done
}

# Install snap and apps
install_snap() {
    if command_exists snap; then
        log "snap is already installed"
    else
        log "Installing snap"
        pm install -y snapd
    fi

    for app in $SNAP_APPS; do
        if is_snap_installed "$app"; then
            log "$app is already installed"
        else
            log "Installing $app"
            sudo snap install "$app" --classic
        fi
    done
}

# Install Timeshift and create backup
install_timeshift() {
    if is_apt_installed timeshift; then
        log "timeshift is already installed"
    else
        log "Installing timeshift"
        pm install -y timeshift
    fi

    if command_exists timeshift && timeshift --list | grep -q "0 snapshots"; then
        log "Creating initial Timeshift backup"
        sudo timeshift --create --comments "Initial backup" --rsync
    else
        log "Timeshift backup already exists or Timeshift not installed"
    fi
}

# Install Ansible
install_ansible() {
    if command_exists ansible; then
        log "ansible is already installed"
    else
        log "Installing ansible"
        pm install -y ansible
    fi
}

# Install Pritunl Client
install_pritunl() {
    if is_apt_installed pritunl-client-electron; then
        log "Pritunl Client is already installed"
        return
    fi
    log "Installing Pritunl Client"
    sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt noble main
EOF
    sudo apt install -y gnupg
    gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A || error "Failed to fetch Pritunl GPG key"
    gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc
    sudo apt update
    sudo apt install -y pritunl-client-electron
    log "Pritunl Client installed successfully"
}

# Remove Pritunl Client
remove_pritunl() {
    log "Removing Pritunl Client"
    sudo pkill -f pritunl || true
    if is_apt_installed pritunl-client-electron; then
        sudo apt purge -y pritunl-client-electron
        sudo apt autoremove -y
    fi
    sudo rm -f /etc/apt/sources.list.d/pritunl.list /etc/apt/trusted.gpg.d/pritunl.asc
    sudo apt-key del 7568D9BB55FF9E5287D586017AE645C0CF8E292A 2>/dev/null || true
    sudo apt update
    rm -rf ~/.config/pritunl ~/.pritunl
    if dpkg -l | grep -q pritunl; then
        log "Warning: Pritunl packages may still be installed"
    fi
    if find / -name '*pritunl*' 2>/dev/null | grep -q .; then
        log "Warning: Residual Pritunl files found. Run 'find / -name \"*pritunl*\"' to locate"
    fi
    log "Pritunl Client removed successfully"
}

# Install Nix
install_nix() {
    if command_exists nix; then
        log "Nix is already installed"
        return
    fi
    log "Installing Nix"
    sh <(curl -L https://nixos.org/nix/install) --no-daemon || error "Nix installation failed"
}

# Configure Nix
configure_nix() {
    if [ -f "$NIX_PROFILE" ]; then
        log "Sourcing Nix profile"
        . "$NIX_PROFILE"
    fi
    if ! grep -q "experimental-features = nix-command flakes" ~/.config/nix/nix.conf 2>/dev/null; then
        log "Enabling Nix flakes"
        mkdir -p ~/.config/nix
        echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
    else
        log "Nix flakes are already enabled"
    fi
}

# Install and configure home-manager
install_home_manager() {
    if [ -f "$HM_DIR/flake.nix" ]; then
        log "home-manager is already initialized"
    else
        log "Initializing home-manager with flakes"
        nix run home-manager -- init || error "home-manager initialization failed"
    fi

    # Copy configuration files
    local configs=(
        "home-manager/home.full.nix:$HM_DIR/home.nix"
        "home-manager/flake.nix:$HM_DIR/flake.nix"
        "zsh/functions.zsh:$CONFIG_DIR/zsh/functions.zsh"
        "zsh/aliases.zsh:$CONFIG_DIR/zsh/aliases.zsh"
        "helix/config.toml:$CONFIG_DIR/helix/config.toml"
        "ghostty/config:$CONFIG_DIR/ghostty/config"
        "zellij/config.kdl:$CONFIG_DIR/zellij/config.kdl"
    )
    for config in "${configs[@]}"; do
        local src="${config%%:*}" dest="${config##*:}"
        src="../../$src"
        mkdir -p "$(dirname "$dest")"
        if [ -f "$src" ]; then
            log "Copying $(basename "$src") to $(dirname "$dest")"
            cp "$src" "$dest"
        else
            log "$(basename "$src") not found at $src"
        fi
    done
}

# Apply home-manager
apply_home_manager() {
    if [ -f "$HM_DIR/home.nix" ]; then
        log "Applying home-manager configuration"
        nix run home-manager --show-trace -- switch --flake "$HM_DIR" || error "home-manager apply failed"
    else
        log "home.nix not found; skipping home-manager activation"
    fi
}

# Remove Nix and home-manager
remove_nix() {
    log "Removing Nix and home-manager"
    local dirs=(
        ~/.nix-profile ~/.nix ~/.nix-channels ~/.nix-defexpr
        ~/.config/nix ~/.config/home-manager
        ~/.local/state/nix ~/.cache/nix
    )
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            log "Removing $dir"
            rm -rf "$dir"
        else
            log "$dir already removed"
        fi
    done

    for shell in ~/.bashrc ~/.zshrc ~/.profile; do
        if [ -f "$shell" ] && grep -q "nix-profile/etc/profile.d/nix.sh" "$shell"; then
            log "Removing Nix from $shell"
            sed -i '/nix-profile\/etc\/profile.d\/nix.sh/d' "$shell"
        else
            log "No Nix shell integration in $shell"
        fi
    done
}

# Main installation function
install_all() {
    update_system
    # install_nala
    install_apt_packages "$APT_PKGS"
    install_timeshift
    install_ansible
    install_flatpak
    install_snap
    install_nix
    configure_nix
    install_home_manager
    apply_home_manager
    install_apt_packages "$QEMU_PKGS"
    install_nvidia_drivers
}

# Main logic
case "$1" in
    install)
        install_all
        install_pritunl
        ;;
    remove)
        remove_pritunl
        remove_nix
        ;;
    *)
        install_all
        install_pritunl
        ;;
esac

log "Installation complete. Log out and back in for group changes to take effect."
exit 0
