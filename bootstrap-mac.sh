#!/usr/bin/env bash
# =============================================================================
# bootstrap-mac.sh — One-command macOS setup (owner or stranger)
# =============================================================================
# Usage:
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/bootstrap-mac.sh)"
#
# Installs Homebrew + Ansible, clones this repo, then hands off to
# `ansible-playbook playbooks/mac.yml`, which does the real work (brew
# bundle, mise runtimes, macOS defaults, dotfiles symlinks, and — only for
# the repo owner, detected via ansible/.vault_pass — decrypting SSH keys).
# =============================================================================

set -euo pipefail

step() { printf '\n\033[1;36m▸ [%s/3] %s\033[0m\n' "$1" "$2"; }
ok()   { printf '\033[0;32m  ✓ %s\033[0m\n' "$*"; }

printf '\033[1;35m●\033[1;34m●\033[1;36m●\033[0m \033[1mdots\033[0m — macOS setup, owner or not\n'

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script targets macOS only." >&2
  exit 1
fi

step 1 "Installing Homebrew"
if ! command -v brew &>/dev/null; then
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ok "Homebrew installed"
else
  ok "Homebrew already installed"
fi
export PATH="/opt/homebrew/bin:$PATH"

if ! command -v ansible-playbook &>/dev/null; then
  brew install ansible
fi
ok "Ansible ready"

step 2 "Fetching dots"
DOTS_DIR="$HOME/dots"
if [[ ! -d "$DOTS_DIR" ]]; then
  git clone https://github.com/TanishBhandari286/ansible-managed-dots.git "$DOTS_DIR"
else
  echo "Already cloned at $DOTS_DIR — pulling latest."
  (cd "$DOTS_DIR" && git pull origin main)
fi
ok "Repo ready at $DOTS_DIR"

cd "$DOTS_DIR/ansible"
if [[ ! -f .vault_pass ]]; then
  echo "No ansible/.vault_pass found — continuing in public mode (no secrets, curated app set)."
  echo "Repo owner? Ctrl+C now, drop your vault password into $DOTS_DIR/ansible/.vault_pass, then re-run."
  sleep 5
  # Placeholder so ansible-playbook can start — ansible.cfg requires this file
  # to exist. mac.yml verifies it actually decrypts before trusting it, so a
  # dummy password here just means "public mode," not a security hole.
  echo "public_mode_dummy_pass" > .vault_pass
  chmod 600 .vault_pass
else
  ok "Vault password found — running as the owner"
fi

step 3 "Running the playbook"
echo "This installs Homebrew packages, applies macOS defaults, and symlinks dotfiles — sit tight."
ansible-playbook playbooks/mac.yml

printf '\n\033[1;35m●\033[1;34m●\033[1;36m●\033[0m \033[1mAll set.\033[0m Run '\''exec zsh'\'' and enjoy. 🎉\n'
