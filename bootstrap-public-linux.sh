#!/usr/bin/env bash
# =============================================================================
# bootstrap-public-linux.sh — One-Command Setup for a fresh Linux (Public Mode)
# =============================================================================
# Usage:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/bootstrap-public-linux.sh)"
# =============================================================================

set -euo pipefail

echo "=========================================================="
echo "  Setting up your Linux machine (Public Mode)..."
echo "=========================================================="

# Ask for the administrator password upfront
echo "We need your password to install system packages..."
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Ansible based on package manager
if ! command -v ansible-playbook &> /dev/null; then
    echo "Installing Ansible..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository --yes --update ppa:ansible/ansible
        sudo apt-get install -y ansible git
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y epel-release
        sudo dnf install -y ansible git
    elif command -v pacman &> /dev/null; then
        sudo pacman -Syu --noconfirm ansible git
    else
        echo "Unsupported package manager. Please install Ansible manually."
        exit 1
    fi
else
    echo "Ansible already installed."
fi

# Clone dotfiles repo via HTTPS
DOTS_DIR="$HOME/dots"
if [[ ! -d "$DOTS_DIR" ]]; then
    echo "Cloning dotfiles repository..."
    git clone https://github.com/TanishBhandari286/ansible-managed-dots.git "$DOTS_DIR"
else
    echo "Dotfiles repository already exists at $DOTS_DIR."
    cd "$DOTS_DIR"
    git pull origin main
fi

# Prepare Ansible
echo "Preparing Ansible for Public Mode..."
cd "$DOTS_DIR/ansible"

# Remove the private vault file so Ansible doesn't try to auto-decrypt it
rm -f group_vars/all/vault.yml

# Create a dummy vault password file to bypass the ansible.cfg requirement
echo "public_mode_dummy_pass" > .vault_pass
chmod 600 .vault_pass

echo "=========================================================="
echo "Running Ansible Playbook (public-linux.yml)..."
# No -K needed because our sudo keep-alive handles authentication
ansible-playbook playbooks/public-linux.yml

echo "=========================================================="
echo "  Setup Complete! Restart your terminal."
echo "=========================================================="
