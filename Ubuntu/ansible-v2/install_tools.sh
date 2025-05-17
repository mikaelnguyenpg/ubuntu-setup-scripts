#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Ubuntu: 1st update & upgrade
sudo apt -y update && sudo apt -y upgrade
# Ubuntu: 2nd Ansible
if ! command_exists "ansible"; then
  echo "Ansible not found. Installing..."
  sudo apt install -y "ansible"
  ansible-galaxy collection install community.general
else
  echo "Ansible is already installed."
fi

# Change to the ansible directory (adjust path if not in ~/)
cd "ansible/" || { echo "Directory ansible/ not found!"; exit 1; }

# Ansible: 2.1 Update & Upgrade
ansible-playbook -i inventory.yml step1-update-upgrade.yml -K
# Ansible: 2.2 Timeshift
ansible-playbook -i inventory.yml step2-timeshift.yml
# Ansible: 2.3 Essentials
ansible-playbook -i inventory.yml step3-essentials.yml
# Ansible: 2.4 Nix
ansible-playbook -i inventory.yml step4-nix.yml
# Ansible: 2.5 Flatpak
ansible-playbook -i inventory.yml step5-flatpak.yml
# Ansible: 2.6 Snap
ansible-playbook -i inventory.yml step6-snap.yml
# Ansible: 2.7 Nvidia drivers, KVMQEMU, Minimize
ansible-playbook -i inventory.yml step7-others.yml
# Ansible: 2.8 Pritunl
ansible-playbook -i inventory.yml step8-pritunl.yml
# Ansible: 2.9 Cleanup
ansible-playbook -i inventory.yml step9-cleanup.yml
# Ansible: 2.11 Flatpak
# Ansible: 2.10 Flatpak

echo "Setup completed!"
