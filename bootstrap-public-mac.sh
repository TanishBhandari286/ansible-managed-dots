#!/usr/bin/env bash
# =============================================================================
# bootstrap-public-mac.sh — One-Command Setup for a fresh Mac (Public Mode)
# =============================================================================
# Usage:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/bootstrap-public-mac.sh)"
# =============================================================================

set -euo pipefail

echo "=========================================================="
echo "  Setting up your Mac (Public Mode)..."
echo "=========================================================="

# Ask for the administrator password upfront
echo "We need your password to install system apps via Homebrew..."
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Install Apple Command Line Tools
if ! command -v xcode-select &> /dev/null || ! xcode-select -p &> /dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    
    echo "Please complete the Xcode CLI tools installation dialog."
    until xcode-select -p &> /dev/null; do
        sleep 5
    done
    echo "Xcode CLI tools installed."
else
    echo "Xcode Command Line Tools already installed."
fi

# Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add brew to PATH for this script session
    if [[ -d /opt/homebrew/bin ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -d /usr/local/bin ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed."
fi

# Install Ansible
if ! command -v ansible-playbook &> /dev/null; then
    echo "Installing Ansible..."
    brew install ansible
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
echo "Running Ansible Playbook (public-mac.yml)..."
ansible-playbook playbooks/public-mac.yml

echo "=========================================================="
echo "  Setup Complete! Restart your terminal."
echo "=========================================================="
