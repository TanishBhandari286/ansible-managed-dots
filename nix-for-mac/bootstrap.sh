#!/usr/bin/env bash
# ── bootstrap.sh ───────────────────────────────────────────────────────
# One-command macOS bootstrap — Xcode CLI Tools → Nix → Homebrew → dotfiles.
#
#   curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/nix-for-mac/bootstrap.sh | bash
#
#   ENV overrides (optional):
#     NIX_USER=alice NIX_HOST=alices-macbook bash bootstrap.sh
# ────────────────────────────────────────────────────────────────────────

set -euo pipefail

DOTFILES_REPO="https://github.com/TanishBhandari286/ansible-managed-dots.git"
DOTFILES_DIR="$HOME/dots"
FLAKE_DIR="$DOTFILES_DIR/nix-for-mac"

RED='\033[1;31m'; GREEN='\033[1;32m'; YELLOW='\033[1;33m'; CYAN='\033[1;36m'; NC='\033[0m'
info()  { printf "${GREEN}[+]${NC} %s\n" "$*"; }
step()  { printf "\n${CYAN}==>${NC} %s\n" "$*"; }
warn()  { printf "${YELLOW}[!]${NC} %s\n" "$*"; }
die()   { printf "${RED}[x] %s${NC}\n" "$*" >&2; exit 1; }

# ── Auto-detect ────────────────────────────────────────────────────────
export NIX_USER="${NIX_USER:-$USER}"
export NIX_HOST="${NIX_HOST:-$(scutil --get LocalHostName 2>/dev/null || echo macbook)}"

# ── Privilege escalation once ──────────────────────────────────────────
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
trap 'kill %1 2>/dev/null || true' EXIT

# ── Step 1: Xcode CLI tools ────────────────────────────────────────────
step "Checking Xcode CLI tools..."
if xcode-select -p &>/dev/null; then
  info "Already installed."
else
  info "Installing (this may take a while)..."
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
  xcode-select --install 2>/dev/null || true
  echo "If prompted, click 'Install' in the GUI dialog."
  until xcode-select -p &>/dev/null; do sleep 5; done
  info "Installed."
fi

# ── Step 2: Homebrew ───────────────────────────────────────────────────
step "Checking Homebrew..."
BREW_BIN=""
if [ -f /opt/homebrew/bin/brew ]; then
  BREW_BIN=/opt/homebrew/bin/brew
elif [ -f /usr/local/bin/brew ]; then
  BREW_BIN=/usr/local/bin/brew
fi

if [ -n "$BREW_BIN" ]; then
  info "Already installed ($BREW_BIN)."
else
  info "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [ -f /opt/homebrew/bin/brew ]; then
    BREW_BIN=/opt/homebrew/bin/brew
  else
    BREW_BIN=/usr/local/bin/brew
  fi
  info "Installed: $("$BREW_BIN" --version | head -1)"
fi

# Ensure brew shellenv is found during this session
eval "$($BREW_BIN shellenv)"

# ── Step 3: Determinate Nix ────────────────────────────────────────────
step "Checking Nix..."
if command -v nix &>/dev/null; then
  info "Already installed: $(nix --version 2>/dev/null | head -1)"
else
  info "Installing Determinate Nix..."
  curl --proto '=https' --tlsv1.2 -sSf -L \
    https://install.determinate.systems/nix | sh -s -- install --no-confirm
  if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
  info "Installed."
fi

# Enable flakes
mkdir -p ~/.config/nix
if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

# ── Step 4: Clone dotfiles ─────────────────────────────────────────────
step "Setting up dotfiles..."
if [ -d "$DOTFILES_DIR" ]; then
  info "Already exists — pulling latest..."
  cd "$DOTFILES_DIR" && git pull --rebase
else
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  info "Cloned to $DOTFILES_DIR."
fi

# ── Step 5: Personal git config reminder ───────────────────────────────
if [ ! -f "$HOME/.gitconfig.local" ]; then
  warn "Creating ~/.gitconfig.local from example — EDIT IT with your details!"
  cp "$DOTFILES_DIR/git/.gitconfig.local.example" "$HOME/.gitconfig.local"
fi

# ── Step 6: Build & activate ───────────────────────────────────────────
step "Building & activating (nix-darwin + home-manager)..."
cd "$FLAKE_DIR"

nix build --impure ".#darwinConfigurations.${NIX_HOST}.system"
./result/sw/bin/darwin-rebuild switch --impure --flake ".#${NIX_HOST}"
rm -f ./result

# ── Step 7: direnv + nix-direnv setup ──────────────────────────────────
step "Setting up direnv..."
mkdir -p "$HOME/.config/direnv"
cat > "$HOME/.config/direnv/direnvrc" <<'DIRENVRC'
source $HOME/.nix-profile/share/nix-direnv/direnvrc
DIRENVRC

# ── Step 8: Decrypt SSH keys (if sops + age key available) ─────────────
step "SSH keys..."
AGE_KEY="$HOME/.config/sops/age/keys.txt"
if [ ! -f "$AGE_KEY" ]; then
  warn "No age key at $AGE_KEY — SSH key decryption skipped."
  warn "To set up: age-keygen -o $AGE_KEY, add the public key to .sops.yaml, re-encrypt keys."
else
  mkdir -p "$HOME/.ssh"
  for enc in "$DOTFILES_DIR"/ssh_keys/*.enc; do
    [ -f "$enc" ] || continue
    name=$(basename "$enc" .enc)
    target="$HOME/.ssh/$name"
    if [ ! -f "$target" ]; then
      nix shell nixpkgs#sops -c sops -d "$enc" > "$target"
      chmod 600 "$target"
      info "Decrypted: $name"
    fi
  done
fi

# ── Done ───────────────────────────────────────────────────────────────
echo ""
info "Bootstrap complete!  User: $NIX_USER  Host: $NIX_HOST"
echo "  brew  → $BREW_BIN"
echo "  nix   → $(which nix)"
info "Open a new terminal or run: exec zsh"
echo ""
echo "  Update everything:  macupdate"
