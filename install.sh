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

banner() {
  printf '\033[1;35m●\033[1;34m●\033[1;36m●\033[0m \033[1mdots\033[0m — laying down your config\n\n'
}

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

# do_links "src1|dest1" "src2|dest2" ...
# Numbers each link [n/total] so the count can't silently drift out of sync —
# it's derived from the array itself, not hand-maintained.
do_links() {
  local pairs=("$@")
  local total=${#pairs[@]}
  local i=0 pair src dest
  for pair in "${pairs[@]}"; do
    i=$((i + 1))
    src="${pair%%|*}"
    dest="${pair#*|}"
    printf '\033[2m  [%d/%d]\033[0m' "$i" "$total"
    link "$src" "$dest"
  done
}

# ---- run --------------------------------------------------------------------

banner
mkdir -p "$HOME/.config"

# macOS was provisioned by nix-for-mac; now it's Ansible + Homebrew, same as
# Linux. Symlink the dotfiles per-platform.
if [[ "$OS" == "Darwin" ]]; then
  echo "── macOS ────────────────────────────────────────────────────────────────"
  mkdir -p "$HOME/.config/tmux" "$HOME/.config/ghostty" "$HOME/.ssh"
  do_links \
    "$DOTS_DIR/.zshrc|$HOME/.zshrc" \
    "$DOTS_DIR/git/.gitconfig|$HOME/.gitconfig" \
    "$DOTS_DIR/.config/nvim|$HOME/.config/nvim" \
    "$DOTS_DIR/.config/starship.toml|$HOME/.config/starship.toml" \
    "$DOTS_DIR/.config/ghostty/config|$HOME/.config/ghostty/config" \
    "$DOTS_DIR/.config/aerospace|$HOME/.config/aerospace" \
    "$DOTS_DIR/.config/tmux/tmux.conf|$HOME/.config/tmux/tmux.conf" \
    "$DOTS_DIR/ssh_keys/config|$HOME/.ssh/config"

  # ~/.gitconfig.local holds personal identity (name/email) — never overwrite
  # it; only seed from the example if it doesn't exist yet.
  if [[ ! -e "$HOME/.gitconfig.local" ]]; then
    cp "$DOTS_DIR/git/.gitconfig.local.example" "$HOME/.gitconfig.local"
    info "Created ~/.gitconfig.local from example — EDIT it with your details!"
  else
    skip "~/.gitconfig.local exists — keeping your personal identity"
  fi

  echo ""
  echo "All set. Run 'exec zsh' to reload your shell — welcome to dots. 🎉"
  exit 0
fi

if [[ "$OS" != "Linux" ]]; then
  printf 'Unsupported OS: %s\n' "$OS" >&2
  exit 1
fi

echo "── Linux ────────────────────────────────────────────────────────────────"
mkdir -p "$HOME/.config/tmux"
do_links \
  "$DOTS_DIR/.zshrc|$HOME/.zshrc" \
  "$DOTS_DIR/git/.gitconfig|$HOME/.gitconfig" \
  "$DOTS_DIR/.config/nvim|$HOME/.config/nvim" \
  "$DOTS_DIR/.config/starship.toml|$HOME/.config/starship.toml" \
  "$DOTS_DIR/.config/tmux/tmux.conf|$HOME/.config/tmux/tmux.conf"

echo ""
echo "All set. Run 'exec zsh' to reload your shell — welcome to dots. 🎉"
