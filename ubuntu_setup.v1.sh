#!/bin/bash

# Ubuntu: 1st update
sudo apt -y update && sudo apt -y upgrade
sudo apt install -y build-essential nala
sudo nala install -y curl ibus-unikey ibus-chewing timeshift

# Nix: install
# wget https://gist.github.com/mikaelnguyenpg/69e0acd9039f58d77d2ca44bfffde5c2/raw -O ubuntu_setup-nix.sh
chmod +x ubuntu_setup-nix.sh
./ubuntu_setup-nix.sh "eagle"

# Pritunl: install
echo " - Running: setup-pritunl.sh"
# wget https://gist.github.com/mikaelnguyenpg/dd7dd3a4d7f8f4f1c619cead181654f6/raw -O ubuntu_setup-pritunl.sh
chmod +x ubuntu_setup-pritunl.sh
./ubuntu_setup-pritunl.sh

echo " - Running: setup-flatpak.sh"
# Flatpak: install
# wget https://gist.github.com/mikaelnguyenpg/3ccc19a0535c7d8c9e630a59f4f98287/raw -O ubuntu_setup-flatpak.sh
chmod +x ubuntu_setup-flatpak.sh
# ./ubuntu_setup-flatpak.sh

# Snap: apps
snap list | grep -q "ghostty " || sudo snap install ghostty --classic
snap list | grep -q "code " || sudo snap install code --classic
snap list | grep -q "webstorm " || sudo snap install webstorm --classic
# Ubuntu: Click to minimize
gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize-or-previews'
# KVM: Virtual-machine
command -v kvm >/dev/null || sudo nala install -y qemu-kvm qemu-utils libvirt-daemon-system libvirt-clients bridge-utils virt-manager ovmf qemu-guest-agent spice-vdagent
# Ubuntu: Install Nvidia drivers
command -v nvidia-smi >/dev/null || sudo ubuntu-drivers devices && sudo ubuntu-drivers autoinstall
# Pyenv: required dependencies
sudo nala install build-essential libssl-dev zlib1g-dev \
  libbz2-dev libreadline-dev libsqlite3-dev \
  libncursesw5-dev xz-utils tk-dev \
  libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# Ubuntu: Cleanup nix & apt
nix-collect-garbage -d

sudo nala autoremove -y
sudo nala clean

# Setup projects
./ubuntu_setup-proj.sh
