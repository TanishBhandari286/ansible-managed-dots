#!/usr/bin/env bash
# =============================================================================
# bootstrap-public-linux.sh — One-Command Setup for a fresh Linux (Public Mode)
# =============================================================================
# Usage:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/bootstrap-public-linux.sh)"
# =============================================================================

set -euo pipefail

# ---- output -----------------------------------------------------------------
step() { printf '\n\033[1;36m▸ [%s/4] %s\033[0m\n' "$1" "$2"; }
ok()   { printf '\033[0;32m  ✓ %s\033[0m\n' "$*"; }

printf '\033[1;35m●\033[1;34m●\033[1;36m●\033[0m \033[1mdots\033[0m — public mode, no keys required\n'
echo "Ansible + Homebrew are about to make themselves at home on this box."

step 1 "Installing Ansible"
echo "Need your password once, up front, for system packages..."
sudo -v
# Keep-alive: update existing `sudo` time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if ! command -v ansible-playbook &> /dev/null; then
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
    ok "Ansible installed"
else
    ok "Ansible already installed"
fi

step 2 "Fetching dots"
DOTS_DIR="$HOME/dots"
if [[ ! -d "$DOTS_DIR" ]]; then
    git clone https://github.com/TanishBhandari286/ansible-managed-dots.git "$DOTS_DIR"
else
    echo "Already cloned at $DOTS_DIR — pulling latest."
    cd "$DOTS_DIR"
    git pull origin main
fi
ok "Repo ready at $DOTS_DIR"

step 3 "Preparing vault-free Ansible config"
cd "$DOTS_DIR/ansible"
# Remove the private vault file so Ansible doesn't try to auto-decrypt it
rm -f group_vars/all/vault.yml
# Create a dummy vault password file to bypass the ansible.cfg requirement
echo "public_mode_dummy_pass" > .vault_pass
chmod 600 .vault_pass
ok "No secrets in play — public-linux.yml never touches the owner's keys"

step 4 "Running the playbook"
echo "This installs Homebrew, your shell, Docker, and dotfiles — sit tight."
# No -K needed because our sudo keep-alive handles authentication
ansible-playbook playbooks/public-linux.yml

printf '\n\033[1;35m●\033[1;34m●\033[1;36m●\033[0m \033[1mAll set.\033[0m Restart your terminal (or run '\''exec zsh'\'') and enjoy. 🎉\n'
