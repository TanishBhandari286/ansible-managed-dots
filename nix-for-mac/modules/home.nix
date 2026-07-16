{ config, lib, pkgs, dotsPath, ... }:

let
  mocha = {
    rosewater = "#f5e0dc";
    pink = "#f5c2e7";
    mauve = "#cba6f7";
    red = "#f38ba8";
    peach = "#fab387";
    yellow = "#f9e2af";
    green = "#a6e3a1";
    sky = "#89dceb";
    blue = "#89b4fa";
    lavender = "#b4befe";
    text = "#cdd6f4";
    surface2 = "#585b70";
    surface1 = "#45475a";
    surface0 = "#313244";
    base = "#1e1e2e";
  };

  zshrcFromTemplate = pkgs.replaceVars ./zshrc.template {
    zshFzfKeyBindings = "${pkgs.fzf}/share/fzf/key-bindings.zsh";
    zshFzfCompletion = "${pkgs.fzf}/share/fzf/completion.zsh";
    zshSyntaxHighlight = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
    zshAutosuggest = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    mocha_rosewater = mocha.rosewater;
    mocha_pink = mocha.pink;
    mocha_mauve = mocha.mauve;
    mocha_red = mocha.red;
    mocha_peach = mocha.peach;
    mocha_yellow = mocha.yellow;
    mocha_green = mocha.green;
    mocha_sky = mocha.sky;
    mocha_blue = mocha.blue;
    mocha_lavender = mocha.lavender;
    mocha_text = mocha.text;
    mocha_surface2 = mocha.surface2;
    mocha_surface1 = mocha.surface1;
    mocha_surface0 = mocha.surface0;
    mocha_base = mocha.base;
  };
in
{
  home.stateVersion = "24.11";
  home.sessionPath = [
    "$HOME/.npm-global/bin"
    "/opt/homebrew/bin"
  ];

  # ══════════════════════════════════════════════════════════════════════════
  # .zshrc — generated from template (needs Nix store path substitution)
  # ══════════════════════════════════════════════════════════════════════════
  home.file.".zshrc".source = zshrcFromTemplate;

  # ══════════════════════════════════════════════════════════════════════════
  # Git config — sourced directly from repo
  # ══════════════════════════════════════════════════════════════════════════
  home.file.".gitconfig".source = dotsPath + "/git/.gitconfig";

  # ══════════════════════════════════════════════════════════════════════════
  # Starship prompt config — sourced directly from repo
  # ══════════════════════════════════════════════════════════════════════════
  xdg.configFile."starship.toml".source = dotsPath + "/.config/starship.toml";

  # ══════════════════════════════════════════════════════════════════════════
  # GhosTTY terminal config — sourced directly from repo
  # ══════════════════════════════════════════════════════════════════════════
  xdg.configFile."ghostty/config".source = dotsPath + "/.config/ghostty/config";

  # ══════════════════════════════════════════════════════════════════════════
  # AeroSpace WM config — sourced directly from repo
  # ══════════════════════════════════════════════════════════════════════════
  xdg.configFile."aerospace/aerospace.toml".source = dotsPath + "/.config/aerospace/aerospace.toml";

  # ══════════════════════════════════════════════════════════════════════════
  # Neovim (LazyVim) — sourced directly from repo
  # ══════════════════════════════════════════════════════════════════════════
  xdg.configFile."nvim" = {
    source = dotsPath + "/.config/nvim";
    recursive = true;
  };

  # ══════════════════════════════════════════════════════════════════════════
  # SSH config — sourced directly from repo
  # ══════════════════════════════════════════════════════════════════════════
  home.file.".ssh/config".source = dotsPath + "/ssh_keys/config";

  # ══════════════════════════════════════════════════════════════════════════
  # direnv with nix-direnv integration
  # ══════════════════════════════════════════════════════════════════════════
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ══════════════════════════════════════════════════════════════════════════
  # htop process viewer
  # ══════════════════════════════════════════════════════════════════════════
  programs.htop.enable = true;
}
