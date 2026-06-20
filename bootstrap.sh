#!/usr/bin/env bash
# =============================================================================
# bootstrap.sh — One-Command Setup for a fresh Mac
# =============================================================================
# Usage:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/bootstrap.sh)"
# =============================================================================

set -euo pipefail

echo "=========================================================="
echo "  Setting up your Mac..."
echo "=========================================================="

# Ask for the administrator password upfront
echo "We need your password to install system apps (like Tailscale) via Homebrew..."
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

# Clone dotfiles repo via HTTPS (SSH keys aren't set up yet on a fresh machine)
DOTS_DIR="$HOME/dots"
if [[ ! -d "$DOTS_DIR" ]]; then
    echo "Cloning dotfiles repository..."
    git clone https://github.com/TanishBhandari286/ansible-managed-dots.git "$DOTS_DIR"
else
    echo "Dotfiles repository already exists at $DOTS_DIR."
    cd "$DOTS_DIR"
    git pull origin main
fi

# Run Ansible Playbook
echo "=========================================================="
cd "$DOTS_DIR/ansible"

# Ask for Ansible Vault password if not present
if [[ ! -f ".vault_pass" ]]; then
    echo -n "Enter Ansible Vault Password (for decryption): "
    read -s VAULT_PASS
    echo ""
    echo "$VAULT_PASS" > ".vault_pass"
    chmod 600 ".vault_pass"
    echo "Vault password saved to .vault_pass"
fi

echo "Running Ansible Playbook..."
# No -K needed because our sudo keep-alive handles Homebrew cask authentications
ansible-playbook playbooks/mac.yml

echo "=========================================================="
echo "  Setup Complete! Restart your terminal."
echo "=========================================================="
