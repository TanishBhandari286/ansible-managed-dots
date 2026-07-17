# ── packages.nix ───────────────────────────────────────────────────────
# CLI tools installed via nixpkgs (system-wide).
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # — Shell & terminal
    zsh-completions
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    tmux
    starship

    # — Core CLI replacements
    bat                                # cat with syntax highlighting
    eza                                # modern ls
    fd                                 # modern find
    ripgrep                            # modern grep
    bottom                             # modern top (btm)
    htop
    tree

    # — Git ecosystem
    git
    delta                              # better diff viewer
    lazygit
    gh                                 # GitHub CLI

    # — Languages & toolchains
    go
    gopls
    rustup
    nodejs_22
    bun
    pnpm
    python314
    uv
    cmake
    pkgs.llvmPackages.openmp

    # — DevOps / containers
    lazydocker
    ansible
    age
    wget
    openssh

    # — Editor
    neovim
    tree-sitter

    # — Fuzzy finding & navigation
    fzf
    zoxide
    mise

    # — Dotfile / system management
    stow
    topgrade

    # — Misc utilities
    pkg-config
    direnv
    nil                                # Nix LSP
    sops                               # secrets management
  ];
}
