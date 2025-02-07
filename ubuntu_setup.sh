#!/bin/bash

# Ubuntu: 1st update
sudo apt -y update && sudo apt -y upgrade
sudo apt install -y build-essential nala
sudo nala install -y curl ibus-unikey ibus-chewing timeshift

# Nix: install
# wget https://gist.github.com/mikaelnguyenpg/69e0acd9039f58d77d2ca44bfffde5c2/raw -O ubuntu_setup-nix.sh
chmod +x ubuntu_setup-nix.sh
./ubuntu_setup-nix.sh

# Pritunl: install
echo " - Running: setup-pritunl.sh"
# wget https://gist.github.com/mikaelnguyenpg/dd7dd3a4d7f8f4f1c619cead181654f6/raw -O ubuntu_setup-pritunl.sh
chmod +x ubuntu_setup-pritunl.sh
./ubuntu_setup-pritunl.sh

echo " - Running: setup-flatpak.sh"
# Flatpak: install
# wget https://gist.github.com/mikaelnguyenpg/3ccc19a0535c7d8c9e630a59f4f98287/raw -O ubuntu_setup-flatpak.sh
chmod +x ubuntu_setup-flatpak.sh
./ubuntu_setup-flatpak.sh

sudo snap install ghostty --classic
sudo snap install code --classic
sudo snap install webstorm --classic
# Ubuntu: Click to minimize
# gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
# Ubuntu: Install Virtual-machine
if ! command -v kvm >/dev/null 2>&1; then
  sudo nala install -y qemu-kvm qemu-utils libvirt-daemon-system libvirt-clients bridge-utils virt-manager ovmf qemu-guest-agent spice-vdagent
fi
# Ubuntu: Install Nvidia drivers
sudo ubuntu-drivers devices && sudo ubuntu-drivers autoinstall

# Ubuntu: Cleanup nix & apt
nix-collect-garbage -d

sudo nala autoremove -y
sudo nala clean


# Setup projects
./ubuntu_setup-proj.sh
