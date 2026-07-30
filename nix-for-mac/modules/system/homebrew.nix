# ── homebrew.nix ───────────────────────────────────────────────────────
# GUI apps and CLI tools via Homebrew.
#
# CLI tools live here rather than in packages.nix (nixpkgs) because
# Homebrew ships prebuilt arm64 bottles for virtually everything below,
# while nixpkgs' aarch64-darwin cache is spottier and falls back to
# local compilation on a cache miss.
{ config, ... }:

{
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";

    # All of these are third-party taps, so Homebrew 6+'s HOMEBREW_REQUIRE_TAP_TRUST
    # refuses to load their formulae/casks unless explicitly marked trusted here.
    taps = [
      {
        name = "nikitabobko/tap";
        trusted = true;
      }
      {
        name = "barutsrb/tap";
        trusted = true;
      }
      {
        name = "can1357/tap";
        trusted = true;
      }
      {
        name = "tw93/tap";
        trusted = true;
      }
    ];

    brews = [
      # — Third-party taps
      "sshs"
      "fontforge"
      "portal"
      "omp"
      "mole"

      # — Shell & terminal
      "zsh-completions"
      "zsh"
      "zsh-autosuggestions"
      "zsh-syntax-highlighting"
      "starship"
      "tmux"

      # — Core CLI replacements
      "bat" # cat with syntax highlighting
      "eza" # modern ls
      "fd" # modern find
      "ripgrep" # modern grep
      "bottom" # modern top (btm)
      "tree"

      # — Git ecosystem
      "git"
      "git-delta" # better diff viewer
      "lazygit"
      "gh" # GitHub CLI

      # — Languages & toolchains
      "go"
      "gopls"
      "node@22" # keg-only -- PATH entry added in zshrc.template
      "bun"
      "pnpm"
      "python@3.14"
      "uv"
      "cmake"
      "libomp"
      "rust" # provides cargo + rustc

      # — DevOps / containers
      "lazydocker"
      "ansible"
      "age"
      "wget"
      "openssh"

      # — Editor
      "neovim"
      "tree-sitter"

      # — Fuzzy finding & navigation
      "fzf"
      "zoxide"
      "mise"

      # — Dotfile / system management
      "stow"
      "topgrade"

      # — Misc utilities
      "pkgconf" # pkg-config
      "nixfmt" # Nix formatter (conform.nvim's "nixfmt")
      "statix" # Nix linter (nvim-lint)
      "sops" # secrets management
    ];

    casks = [
      "ghostty"
      "barutsrb/tap/omniwm"
      "aerospace"
      "antigravity"
      "brave-browser"
      "claude-code"
      "font-jetbrains-mono"
      "gcloud-cli"
      "iina"
      "obs"
      "obsidian"
      "orbstack"
      "raycast"
      "syncthing-app"
      "visual-studio-code"
      "whatsapp"
      "zap"
      "zed"
      "firefox"
      "cursor-cli"
      "cursor"
    ];

    masApps = { };
  };
}
