#!/bin/bash

# install-tools.sh
# Installs and configures tools on Ubuntu 24.04, with Nix/Flakes/Home-Manager focus.
# Usage: ./install-tools.sh [install|remove|help]
# Check session type: `echo $XDG_SESSION_TYPE` # Wayland, X11
# Install x11 session: `x11-apps`
# Ref: https://youtu.be/vLm2EHIaxOo?si=fn4AO2H4MCXV6rTK&t=552

set -e

# Constants
NIX_PROFILE="$HOME/.nix-profile/etc/profile.d/nix.sh"
CONFIG_DIR="$HOME/.config"
HM_DIR="$CONFIG_DIR/home-manager"
SCRIPT_DIR="$(dirname "$(realpath "$0")")"  # Absolute path to script dir
HM_FLAKE_DIR="$SCRIPT_DIR/../../home-manager"  # Adjust if needed
APT_PKGS="curl build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev ibus-unikey ibus-chewing x11-apps ffmpeg"
QEMU_PKGS="qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager"
FLUTTER_PKGS="ninja-build pkg-config libgtk-3-dev libstdc++-12-dev libopencv-dev"  # Included commented ones: clang cmake
FLATPAK_APPS=""
TAURI_PKGS="libwebkit2gtk-4.1-dev build-essential curl wget file libxdo-dev libssl-dev libayatana-appindicator3-dev librsvg2-dev"

# Logging
log() { printf "[INFO] %s\n" "$1"; }
error() { printf "[ERROR] %s\n" "$1" >&2; exit 1; }
section() { printf "\n=== %s ===\n" "$1"; }

# Check if command exists
command_exists() { command -v "$1" >/dev/null 2>&1; }

# Dynamic package manager (prefer nala if available)
pm() {
    if command_exists nala; then
        sudo nala "$@"
    else
        sudo apt "$@"
    fi
}

# Check if apt package is installed
is_apt_installed() { dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"; }

# Check if Flatpak package is installed
is_flatpak_installed() {
    local app_id="$1"
    flatpak list --app --columns=application 2>/dev/null |
        grep -Fxq "$app_id"
}

# Update and upgrade system
update_system() {
    section "Updating and Upgrading System"
    pm update && pm upgrade -y
    if command_exists nala; then
        sudo nala fetch --auto -y
    fi
}

# Install nala
install_nala() {
    section "Installing Nala (Faster APT Frontend)"
    if command_exists nala; then
        log "nala is already installed"
        return
    fi
    log "Installing nala"
    sudo apt install -y nala
}

# Install apt packages (batch for speed)
install_apt_packages() {
    local pkgs_to_install=""
    for pkg in $@; do
        if ! is_apt_installed "$pkg"; then
            pkgs_to_install="$pkgs_to_install $pkg"
        else
            log "$pkg is already installed"
        fi
    done
    if [ -n "$pkgs_to_install" ]; then
        section "Installing APT Packages: $pkgs_to_install"
        pm install -y $pkgs_to_install
    else
        log "All specified APT packages are already installed"
    fi
}

# Install Nvidia-drivers
install_nvidia_drivers() {
    section "Installing NVIDIA Drivers"
    lspci | grep -E "VGA|3D"
    ubuntu-drivers devices
    if ! is_apt_installed nvidia-driver; then  # Check for any nvidia-driver
        log "Auto-installing recommended NVIDIA driver"
        # pm install -y --install-recommends ubuntu-drivers-common
        # pm install -y nvidia-driver-580
        sudo ubuntu-drivers install
    else
        log "NVIDIA drivers already installed"
    fi
}

# Install flatpak and apps
install_flatpak() {
    section "Installing Flatpak"

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

# Install Timeshift and create backup
install_timeshift() {
    section "Installing Timeshift (System Backup Tool)"
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
    section "Installing Ansible"
    if command_exists ansible; then
        log "ansible is already installed"
    else
        log "Installing ansible"
        pm install -y ansible
    fi
}

# Install Pritunl Client
install_pritunl() {
    section "Installing Pritunl VPN Client"
    if is_apt_installed pritunl-client-electron; then
        log "Pritunl Client is already installed"
        return
    fi
    log "Adding Pritunl repository"
    echo "deb https://repo.pritunl.com/stable/apt noble main" | sudo tee /etc/apt/sources.list.d/pritunl.list
    sudo apt install -y gnupg
    gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A || error "Failed to fetch Pritunl GPG key"
    gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc
    pm update
    pm install -y pritunl-client-electron
    log "Pritunl Client installed successfully"
}

# Remove Pritunl Client
remove_pritunl() {
    section "Removing Pritunl VPN Client"
    sudo pkill -f pritunl || true
    if is_apt_installed pritunl-client-electron; then
        pm purge -y pritunl-client-electron
        pm autoremove -y
    fi
    sudo rm -f /etc/apt/sources.list.d/pritunl.list /etc/apt/trusted.gpg.d/pritunl.asc
    sudo apt-key del 7568D9BB55FF9E5287D586017AE645C0CF8E292A 2>/dev/null || true
    pm update
    rm -rf ~/.config/pritunl ~/.pritunl
    if dpkg -l | grep -q pritunl; then
        log "Warning: Pritunl packages may still be installed"
    fi
    log "Pritunl Client removed successfully"
}

# Install Nix
install_nix() {
    section "Installing Nix Package Manager"
    if command_exists nix; then
        log "Nix is already installed"
        return
    fi
    log "Installing Nix (single-user mode)"
    sh <(curl -L https://nixos.org/nix/install) --no-daemon || error "Nix installation failed"
}

# Configure Nix
configure_nix() {
    section "Configuring Nix (Enabling Flakes)"
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
    section "Installing Home-Manager (via Nix Flakes)"
    if [ -f "$HM_DIR/flake.nix" ]; then
        log "home-manager is already initialized"
    else
        log "Initializing home-manager with flakes"
        nix run home-manager -- init || error "home-manager initialization failed"
    fi

    log "Syncing home-manager configuration from $HM_FLAKE_DIR"
    cp -rv "$HM_FLAKE_DIR"/* "$HM_DIR/"  # Uncommented and fixed; adjust if needed
    # Example: cp "$SCRIPT_DIR/../../ghostty/config" "$CONFIG_DIR/ghostty/config"
}

# Apply home-manager
apply_home_manager() {
    section "Applying Home-Manager Configuration"
    if [ -f "$HM_DIR/home.nix" ]; then
        log "Switching to new home-manager config"
        nix run home-manager --show-trace -- switch --flake "$HM_FLAKE_DIR" || error "home-manager apply failed"
    else
        log "home.nix not found; skipping home-manager activation"
    fi
}

# Remove Nix and home-manager
remove_nix() {
    section "Removing Nix and Home-Manager"
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
    # For multi-user installs: /nix/nix-installer uninstall (if applicable)
}

# Install Docker
install_docker() {
    section "Installing Docker"
    if command_exists docker; then
        log "Docker is already installed. Skipping..."
        return
    fi

    local DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
    local CODENAME=$(lsb_release -cs)
    local KEYRING="/etc/apt/keyrings/docker.gpg"

    sudo apt-get update -qq
    sudo apt-get install -y -qq ca-certificates curl gnupg > /dev/null

    sudo mkdir -p -m 0755 /etc/apt/keyrings
    curl -fsSL "https://download.docker.com/linux/$DISTRO/gpg" | sudo gpg --dearmor --yes -o "$KEYRING"
    sudo chmod a+r "$KEYRING"

    echo "deb [arch=$(dpkg --print-architecture) signed-by=$KEYRING] https://download.docker.com/linux/$DISTRO $CODENAME stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    pm update -qq
    pm install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null

    sudo usermod -aG docker "$USER"
    sudo systemctl enable --now docker > /dev/null 2>&1

    log "✅ Docker installed successfully."
    log "⚠️  To use docker without sudo, log out and back in."
}

# Install QEMU/KVM
install_qemu_kvm() {
    section "Installing QEMU/KVM and Libvirt"
    if command_exists virsh; then
        log "QEMU-KVM/Libvirt is already installed. Skipping..."
        return
    fi

    install_apt_packages $QEMU_PKGS

    log "Configuring permissions..."
    sudo usermod -aG libvirt "$USER"
    sudo usermod -aG kvm "$USER"

    sudo systemctl enable --now libvirtd

    if command_exists kvm-ok; then
        kvm-ok || log "Warning: KVM acceleration not supported or not enabled in BIOS."
    fi

    log "✅ QEMU-KVM setup complete. Relogin for group changes."
}

# Main installation function
install_all() {
    install_nala  # Early for speed
    update_system
    install_apt_packages $APT_PKGS
    install_nvidia_drivers
    install_timeshift
    install_ansible
    install_docker
    install_flatpak
    install_nix
    configure_nix
    install_home_manager
    apply_home_manager
    install_qemu_kvm
    install_apt_packages $FLUTTER_PKGS
    install_apt_packages $TAURI_PKGS
}

# Help message
show_help() {
    echo "Usage: $0 [install|remove|help]"
    echo "  install: Install all tools (default)"
    echo "  remove: Remove Pritunl and Nix/Home-Manager"
    echo "  help: Show this message"
    exit 0
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
    help)
        show_help
        ;;
    *)
        install_all
        install_pritunl
        ;;
esac

log "Installation complete. Log out and back in for group changes to take effect."
exit 0


npm create tauri-app@latest
cd my-app
npm install
npm run tauri dev

npx create-next-app@latest my-tauri-app
npx tauri init

sudo apt update
sudo apt install -y libpango-1.0-0
sudo apt install -y libgtk-3-0 libwebkit2gtk-4.1-0 libjavascriptcoregtk-4.1-0
sudo ldconfig
npm run tauri dev

sudo apt update
sudo apt install -y libwebkit2gtk-4.1-dev build-essential curl wget libssl-dev libgtk-3-dev libayatana-appindicator3-dev librsvg2-dev

sudo apt purge '^nvidia-.*'
sudo apt autoremove
sudo apt autoclean

ubuntu-drivers devices
sudo ubuntu-drivers install
sudo reboot
sudo prime-select nvidia



