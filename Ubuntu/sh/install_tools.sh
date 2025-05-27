#!/bin/sh

# Simple script to install apps and tools on Ubuntu 24.04
# Compatible with bash and zsh
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if an apt package is installed
is_apt_installed() {
    dpkg-query --show --showformat='${Status}\n' "$1" 2>/dev/null | grep -q "install ok installed"
}

# Function to check if a flatpak app is installed
is_flatpak_installed() {
    flatpak list | grep -q "$1"
}

# Function to check if a snap package is installed
is_snap_installed() {
    snap list "$1" >/dev/null 2>&1
}

# Log message
log() {
    echo "[INFO] $1"
}

# Install Nix in single-user mode
install_nix() {
    if ! command_exists nix; then
        log "Installing Nix"
        sh <(curl -L https://nixos.org/nix/install) --no-daemon
    else
        log "Nix is already installed"
    fi
}

# Source Nix profile and enable flakes
configure_nix() {
    if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        log "Sourcing Nix profile"
        . "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi

    if ! grep -q "experimental-features = nix-command flakes" ~/.config/nix/nix.conf 2>/dev/null; then
        log "Enabling Nix flakes"
        mkdir -p ~/.config/nix
        echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
    else
        log "Nix flakes are already enabled"
    fi
}

# Initialize home-manager with flakes and copy home.full.nix
install_home_manager() {
    if [ ! -f ~/.config/home-manager/flake.nix ]; then
        log "Initializing home-manager with flakes"
        nix run home-manager -- init
    else
        log "home-manager is already initialized"
    fi

    # # Install home-manager
    # if ! command_exists home-manager; then
    #   log "Installing home-manager"
    #   nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    #   nix-channel --update
    #   nix-shell '<home-manager>' -A install
    # else
    #     log "home-manager is already installed"
    # fi

    SAMPLE_DIR="../../home-manager"
    HOME_DIR="$HOME/.config/home-manager"
    SAMPLE_NIX="$SAMPLE_DIR/home.full.nix"
    SAMPLE_FLAKE="$SAMPLE_DIR/flake.nix"
    SAMPLE_FUNCTIONS="$SAMPLE_DIR/functions.zsh"
    SAMPLE_ALIASES="$SAMPLE_DIR/aliases.zsh"
    HOME_NIX="$HOME_DIR/home.nix"
    HOME_FLAKE="$HOME_DIR/flake.nix"
    HOME_FUNCTIONS="$HOME_DIR/functions.zsh"
    HOME_ALIASES="$HOME_DIR/aliases.zsh"

    if [ -f "$SAMPLE_NIX" ]; then
        log "Copying home.full.nix to home.nix"
        cp "$SAMPLE_NIX" "$HOME_NIX"
    else
        log "home.full.nix not found at $SAMPLE_NIX"
        exit 1
    fi

    if [ -f "$SAMPLE_FLAKE" ]; then
        log "Copying home.full.nix to home.nix"
        cp "$SAMPLE_FLAKE" "$HOME_FLAKE"
    else
        log "flake.nix not found at $SAMPLE_FLAKE"
        exit 1
    fi

    if [ -f "$SAMPLE_FUNCTIONS" ]; then
        log "Copying functions.zsh to $HOME_DIR"
        cp "$SAMPLE_FUNCTIONS" "$HOME_FUNCTIONS"
    else
        log "functions.zsh not found at $SAMPLE_FUNCTIONS"
    fi

    if [ -f "$SAMPLE_ALIASES" ]; then
        log "Copying aliases.zsh to $HOME_DIR"
        cp "$SAMPLE_ALIASES" "$HOME_ALIASES"
    else
        log "aliases.zsh not found at $SAMPLE_ALIASES"
    fi
}

# Apply home-manager configuration
apply_home_manager() {
    HOME_NIX="$HOME/.config/home-manager/home.nix"
    if [ -f "$HOME_NIX" ]; then
        log "Applying home-manager configuration"
        nix run home-manager/release-24.11 -- switch --flake ~/.config/home-manager
        # nix-collect-garbage -d
    else
        log "home.nix not found; skipping home-manager activation"
    fi

    # if [ -f ~/.config/home-manager/home.nix ]; then
    #     log "Install home-manager packages"
    #     home-manager switch --show-trace
    #     nix-collect-garbage -d
    # else
    #     log "home-manager is NOT available"
    # fi
}

# Remove Nix, home-manager, and related files
remove_nix() {
    if [ -d ~/.nix-profile ] || [ -d ~/.nix ]; then
        log "Removing Nix profile and store"
        rm -rf ~/.nix-profile ~/.nix
    else
        log "Nix profile and store already removed"
    fi

    if [ -d ~/.nix-channels ] || [ -d ~/.nix-defexpr ]; then
        log "Removing Nix channels"
        rm -rf ~/.nix-channels ~/.nix-defexpr
    else
        log "Nix channels already removed"
    fi

    if [ -d ~/.config/nix ]; then
        log "Removing Nix configuration"
        rm -rf ~/.config/nix
    else
        log "Nix configuration already removed"
    fi

    if [ -d ~/.config/home-manager ]; then
        log "Removing home-manager configuration"
        rm -rf ~/.config/home-manager
    else
        log "home-manager configuration already removed"
    fi

    if [ -d ~/.local/state/nix ] || [ -d ~/.cache/nix ]; then
        log "Removing Nix state and cache"
        rm -rf ~/.local/state/nix ~/.cache/nix
    else
        log "Nix state and cache already removed"
    fi

    for shell_config in ~/.bashrc ~/.zshrc ~/.profile; do
        if [ -f "$shell_config" ] && grep -q "nix-profile/etc/profile.d/nix.sh" "$shell_config"; then
            log "Removing Nix from $shell_config"
            sed -i '/nix-profile\/etc\/profile.d\/nix.sh/d' "$shell_config"
        else
            log "No Nix shell integration found in $shell_config"
        fi
    done
}

# Update and upgrade system
log "Updating and upgrading system"
if command_exists nala; then
    sudo nala update && sudo nala upgrade -y
else
    sudo apt update && sudo apt upgrade -y
fi

# Install nala if not present
if ! command_exists nala; then
    log "Installing nala"
    sudo apt install -y nala
    sudo nala fetch --auto -y
else
    log "nala is already installed"
fi

# Install essential packages
ESSENTIALS="curl git build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev"
for pkg in $ESSENTIALS; do
    if is_apt_installed "$pkg"; then
        log "$pkg is already installed"
    else
        log "Installing $pkg"
        sudo apt install -y "$pkg"
    fi
done

# Install Timeshift and create initial backup
if is_apt_installed timeshift; then
    log "timeshift is already installed"
else
    log "Installing timeshift"
    sudo apt install -y timeshift
fi

# Check for existing Timeshift backups and create one if none exist
if command_exists timeshift; then
    if timeshift --list | grep -q "0 snapshots"; then
        log "Creating initial Timeshift backup"
        timeshift --create --comments "Initial backup" --rsync
    else
        log "Timeshift backup already exists"
    fi
else
    log "Timeshift not installed; skipping backup"
fi

# Install ansible
if command_exists ansible; then
    log "ansible is already installed"
else
    log "Installing ansible"
    sudo apt install -y ansible
fi

# Install flatpak and flatpak apps
if ! command_exists flatpak; then
    log "Installing flatpak"
    sudo apt install -y flatpak
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
else
    log "flatpak is already installed"
fi

# FLATPAK_APPS="com.google.Chrome com.obsproject.Studio io.httpie.Httpie md.obsidian.Obsidian org.jousse.vincent.Pomodorolm org.libreoffice.LibreOffice org.signal.Signal"
FLATPAK_APPS=""
for app in $FLATPAK_APPS; do
    if is_flatpak_installed "$app"; then
        log "$app is already installed"
    else
        log "Installing $app"
        flatpak install -y flathub "$app"
    fi
done

# Install snap and snap apps
if ! command_exists snap; then
    log "Installing snap"
    sudo apt install -y snapd
else
    log "snap is already installed"
fi

SNAP_APPS="ghostty"
for app in $SNAP_APPS; do
    if is_snap_installed "$app"; then
        log "$app is already installed"
    else
        log "Installing $app"
        snap install "$app" --classic
    fi
done

# Main logic for Nix installation or removal
INSTALL_NIX=true # Set to true to install, false to remove

if [ "$INSTALL_NIX" = "true" ]; then
    install_nix
    configure_nix
    install_home_manager
    apply_home_manager
else
    remove_nix
fi

# Install QEMU/KVM and virtualization tools
QEMU_PKGS="qemu-kvm qemu-utils libvirt-daemon-system libvirt-clients bridge-utils virt-manager ovmf qemu-guest-agent" # spice-vdagent samba
for pkg in $QEMU_PKGS; do
    if is_apt_installed "$pkg"; then
        log "$pkg is already installed"
    else
        log "Installing $pkg"
        sudo apt install -y "$pkg"
    fi
done

# # Enable and start libvirtd service
# if systemctl is-active --quiet libvirtd; then
#     log "libvirtd service is already running"
# else
#     log "Enabling and starting libvirtd service"
#     systemctl enable libvirtd
#     systemctl start libvirtd
# fi

# # Add user to libvirt group
# if groups "$USER" | grep -q libvirt; then
#     log "User $USER is already in libvirt group"
# else
#     log "Adding user $USER to libvirt group"
#     usermod -aG libvirt "$USER"
# fi

# # Install Pritunl VPN Client
# if is_apt_installed pritunl-client-electron; then
#     log "pritunl-client-electron is already installed"
# else
#     log "Installing Pritunl VPN Client"
#     # Add Pritunl APT repository
#     if [ ! -f /etc/apt/sources.list.d/pritunl.list ]; then
#         log "Adding Pritunl APT repository"
#         sudo sh -c "printf 'deb https://repo.pritunl.com/stable/apt oracular main\n' > /etc/apt/sources.list.d/pritunl.list"
#     else
#         log "Pritunl APT repository already exists"
#     fi
#
#     # Install gnupg
#     if is_apt_installed gnupg; then
#         log "gnupg is already installed"
#     else
#         log "Installing gnupg"
#         sudo apt install -y gnupg
#     fi
#
#     # Import Pritunl GPG key
#     if [ ! -f /etc/apt/trusted.gpg.d/pritunl.asc ]; then
#         log "Importing Pritunl GPG key"
#         gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
#         gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc > /dev/null
#     else
#         log "Pritunl GPG key already imported"
#     fi
#
#     # Update APT cache
#     log "Updating APT cache for Pritunl"
#     sudo apt update
#
#     # Install pritunl-client-electron
#     log "Installing pritunl-client-electron"
#     sudo apt install -y pritunl-client-electron
# fi

log "Installation complete. Please log out and log back in for group changes to take effect."
exit 0
