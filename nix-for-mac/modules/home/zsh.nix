# ── home/zsh.nix ───────────────────────────────────────────────────────
# Generates ~/.zshrc from the template, injecting Nix store paths and colors.
{ pkgs, ... }:

let
  mocha = (import ./colors.nix).mocha;
  zshrc = pkgs.replaceVars ../zshrc.template {
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
  home.file.".zshrc".source = zshrc;
}
