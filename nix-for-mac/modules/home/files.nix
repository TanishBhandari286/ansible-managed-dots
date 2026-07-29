# ── home/files.nix ─────────────────────────────────────────────────────
# Symlinks dotfiles from the repo into ~/ and ~/.config/.
{ config, dotsPath, ... }:

{
  home.sessionPath = [
    "$HOME/.npm-global/bin"
    "/opt/homebrew/bin"
  ];

  home.file.".gitconfig".source = dotsPath + "/git/.gitconfig";
  home.file.".ssh/config".source = dotsPath + "/ssh_keys/config";

  xdg.configFile = {
    "ghostty/config".source = dotsPath + "/.config/ghostty/config";
    "starship.toml".source = dotsPath + "/.config/starship.toml";
    "aerospace/aerospace.toml".source = dotsPath + "/.config/aerospace/aerospace.toml";
    # Out-of-store symlink (not a recursive store copy): lazy.nvim needs to
    # write lazy-lock.json at runtime, which a Nix-store-backed recursive
    # symlink can never allow (read-only). This points straight at the live
    # repo checkout instead.
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dots/.config/nvim";
  };
}

# NOTE: ~/.zshrc is handled by home/zsh.nix (requires Nix store path substitution).
