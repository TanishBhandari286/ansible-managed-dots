#!/usr/bin/env bash
# =============================================================================
# install.sh — Dotfiles symlink installer
# =============================================================================
# Usage:
#   ~/dots/install.sh
#   ~/dots/install.sh --dry-run
# =============================================================================

set -euo pipefail

DOTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup"
OS="$(uname -s)"
DRY_RUN=false

[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

# ---- output -----------------------------------------------------------------

ok()     { printf '\033[0;32m  ✓\033[0m %s\n' "$*"; }
skip()   { printf '\033[0;33m  –\033[0m %s\n' "$*"; }
info()   { printf '\033[0;34m  →\033[0m %s\n' "$*"; }
dry()    { printf '\033[0;35m  ~\033[0m %s\n' "$*"; }

# ---- link -------------------------------------------------------------------
#
# link SRC DEST
#
# Behaviour:
#   1. Dry-run: print and return.
#   2. DEST is already a symlink: remove it and re-link (ln -sfn semantics,
#      portable across macOS + Linux without readlink comparison).
#   3. DEST is a real file or directory: move it to $BACKUP_DIR once, then link.
#   4. DEST does not exist: create the symlink.

link() {
  local src="$1"
  local dest="$2"
  local name
  name="$(basename "$dest")"

  if [[ "$DRY_RUN" == true ]]; then
    dry "ln -sfn $src -> $dest"
    return
  fi

  # Existing symlink — replace unconditionally (avoids readlink portability issues)
  if [[ -L "$dest" ]]; then
    ln -sfn "$src" "$dest"
    ok "$name"
    return
  fi

  # Real file or directory — back up once into $BACKUP_DIR
  if [[ -e "$dest" ]]; then
    mkdir -p "$BACKUP_DIR"
    info "Backing up $dest → $BACKUP_DIR/$name"
    mv "$dest" "$BACKUP_DIR/$name.$(date +%s)"
  fi

  ln -sf "$src" "$dest"
  ok "$name"
}

# ---- run --------------------------------------------------------------------

mkdir -p "$HOME/.config"

# macOS is provisioned by nix-for-mac (nix-darwin + home-manager) instead —
# see nix-for-mac/bootstrap.sh. This script only runs via the Linux ansible
# dotfiles role.
if [[ "$OS" != "Linux" ]]; then
  printf 'Unsupported OS: %s (macOS uses nix-for-mac/bootstrap.sh instead)\n' "$OS" >&2
  exit 1
fi

echo ""
echo "── Linux ────────────────────────────────────────────────────────────────"
link "$DOTS_DIR/.zshrc"                 "$HOME/.zshrc"
link "$DOTS_DIR/git/.gitconfig"         "$HOME/.gitconfig"
link "$DOTS_DIR/.config/nvim"           "$HOME/.config/nvim"

echo ""
echo "Done. Run 'exec zsh' to reload your shell."
