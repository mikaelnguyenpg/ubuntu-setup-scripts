#!/bin/sh

# Simple script to install Ansible and run playbook for tools/apps on Ubuntu 24.04
# Compatible with bash and zsh
set -e

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Log message
log() {
    echo "[INFO] $1"
}

# Update package index
log "Updating package index"
if command_exists nala; then
    nala update
else
    apt update
fi

# Install Ansible if not present
if command_exists ansible; then
    log "Ansible is already installed"
else
    log "Installing Ansible"
    if command_exists nala; then
        nala install -y ansible
    else
        apt install -y ansible
    fi
fi

# # Create Ansible directory
# ANSIBLE_DIR="$HOME/ansible"
# if [ -d "$ANSIBLE_DIR" ]; then
#     log "Ansible directory $ANSIBLE_DIR already exists"
# else
#     log "Creating Ansible directory $ANSIBLE_DIR"
#     mkdir -p "$ANSIBLE_DIR"
# fi

# Run Ansible playbook
log "Running Ansible playbook to install tools and apps"
# ansible-playbook "$ANSIBLE_DIR/install_tools.yml"
ansible-playbook "install_tools.yml"

log "Installation complete. Please log out and log back in for group changes to take effect."
exit 0
