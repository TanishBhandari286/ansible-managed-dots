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
    "starship.toml".source = dotsPath + "/.config/starship.toml";
    "ghostty/config".source = dotsPath + "/.config/ghostty/config";
    "aerospace/aerospace.toml".source = dotsPath + "/.config/aerospace/aerospace.toml";
    "nvim" = {
      source = dotsPath + "/.config/nvim";
      recursive = true;
    };
  };
}

# NOTE: ~/.zshrc is handled by home/zsh.nix (requires Nix store path substitution).
