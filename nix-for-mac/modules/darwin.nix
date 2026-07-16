# ── darwin.nix — macOS system-level configuration ──────────────────────
# Replaces: Ansible roles/packages/tasks/darwin.yml (Homebrew install + bundle)
#           and macOS system defaults that Ansible would set.
{ config, lib, pkgs, username, dotsPath, ... }:

{
  # ── nix-darwin required settings ───────────────────────────────────────
  system.stateVersion = 7;
  system.primaryUser = username;
  # ── System packages (CLI tools, available in nixpkgs) ──────────────────
  environment.systemPackages = with pkgs; [
    # ---- Shell & terminal --------------------------------------------------
    zsh-completions
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    tmux
    starship

    # ---- Core CLI replacements ---------------------------------------------
    bat                              # cat with syntax highlighting
    eza                              # modern ls
    fd                               # modern find
    ripgrep                          # modern grep
    bottom                           # modern top (btm)
    htop
    tree

    # ---- Git ecosystem ----------------------------------------------------
    git
    delta                            # git-delta: better diff viewer
    lazygit
    gh                               # GitHub CLI

    # ---- Languages & toolchains -------------------------------------------
    go
    gopls                            # Go language server
    rustup                           # Rust (via rustup for latest stable)
    nodejs_22                        # Node.js LTS
    bun                              # Fast JS runtime
    pnpm                             # Fast package manager
    python314                        # Python 3.14
    uv                               # Fast Python package installer (replaces pip)
    cmake
    pkgs.llvmPackages.openmp         # OpenMP for ML builds

    # ---- DevOps / containers -----------------------------------------------
    lazydocker
    ansible                          # stays for remaining Ansible-managed hosts
    age                              # encryption (replaces ansible-vault eventually)
    wget
    openssh

    # ---- Editor ------------------------------------------------------------
    neovim
    tree-sitter                      # incremental parsing library

    # ---- Fuzzy finding & navigation ----------------------------------------
    fzf
    zoxide
    mise                             # polyglot runtime manager

    # ---- Dotfile / system management ---------------------------------------
    stow
    topgrade                         # upgrade everything

    # ---- Misc utilities ----------------------------------------------------
    pkg-config
    direnv
    nil                              # Nix language server
    sops                             # secrets management
  ];

  # ── Homebrew casks for GUI apps not in nixpkgs ─────────────────────────
  homebrew = {
    enable = true;
    onActivation.cleanup = "none";     # brew cleanup fails as root; run manually as user

    taps = [
      "nikitabobko/tap"
      "barutsrb/tap"
      "can1357/tap"
      "tw93/tap"
    ];

    brews = [
      "can1357/tap/omp"              # CommandCode OMP (private tap — not in nixpkgs)
      "tw93/tap/mole"                # mac cleaner
      "sshs"                         # graphical SSH client
      "portal"                       # file transfer utility
      "omp"
    ];

    casks = [
      "ghostty"                      # terminal emulator (not in nixpkgs on darwin)
      "barutsrb/tap/omniwm"          # OmniWM tiling WM (installed via cask, not formula)
      "aerospace"                    # i3-like tiling WM
      "antigravity"                  # agent orchestration
      "brave-browser"
      "font-jetbrains-mono"          # Nerd Font
      "gcloud-cli"
      "helium-browser"
      "iina"                         # media player
      "obs"                          # OBS Studio
      "obsidian"                     # notes
      "orbstack"                     # Docker Desktop replacement
      "raycast"                      # launcher
      "syncthing-app"                # file sync
      "visual-studio-code"
      "whatsapp"
      "zap"                          # multiplayer IDE
      "zed"                          # editor
    ];

    # ── VS Code extensions ───────────────────────────────────────────────
    masApps = { };                   # no Mac App Store apps
  };

  # ── macOS system defaults ──────────────────────────────────────────────
  system.defaults = {
    # Dock
    dock.autohide = true;
    dock.mru-spaces = false;
    dock.orientation = "bottom";

    # Finder
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "Nlsv";  # list view
    finder.ShowPathbar = true;
    finder.ShowStatusBar = true;

    # Keyboard
    NSGlobalDomain.AppleKeyboardUIMode = 3;   # full keyboard access
    NSGlobalDomain.KeyRepeat = 2;             # fast key repeat
    NSGlobalDomain.InitialKeyRepeat = 15;

    # Trackpad
    trackpad.Clicking = true;
    trackpad.TrackpadThreeFingerDrag = true;

    # Screenshots
    screencapture.location = "~/Pictures/Screenshots";
  };

  # ── Nix managed by Determinate, not nix-darwin ──────────────────────────
  nix.enable = false;

  # ── Allow unfree packages (VS Code, OrbStack, etc.) ────────────────────
  nixpkgs.config.allowUnfree = true;

  # ── sops — secrets management CLI (decrypt SSH keys manually or via script) ──
  # SSH keys are encrypted at ssh_keys/*.enc in the repo.
  # Decrypt on first bootstrap:
  #   sops -d ~/dots/ssh_keys/id_ed25519_ansible.enc > ~/.ssh/id_ed25519_ansible
  #   chmod 600 ~/.ssh/id_ed25519_ansible
}
