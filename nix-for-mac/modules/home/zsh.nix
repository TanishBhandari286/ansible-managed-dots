# ── home/zsh.nix ───────────────────────────────────────────────────────
# Generates ~/.zshrc from the template, injecting Nix store paths and colors.
{ pkgs, ... }:

let
  tokyonight = (import ./colors.nix).tokyonight;

  zshrc = pkgs.replaceVars ../zshrc.template {
    zshFzfKeyBindings = "${pkgs.fzf}/share/fzf/key-bindings.zsh";
    zshFzfCompletion = "${pkgs.fzf}/share/fzf/completion.zsh";
    zshSyntaxHighlight = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
    zshAutosuggest = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    tn_bg = tokyonight.bg;
    tn_bg_highlight = tokyonight.bg_highlight;
    tn_fg = tokyonight.fg;
    tn_comment = tokyonight.comment;
    tn_blue = tokyonight.blue;
    tn_cyan = tokyonight.cyan;
    tn_magenta = tokyonight.magenta;
    tn_magenta2 = tokyonight.magenta2;
    tn_purple = tokyonight.purple;
    tn_orange = tokyonight.orange;
    tn_yellow = tokyonight.yellow;
    tn_green = tokyonight.green;
    tn_red = tokyonight.red;
  };
in
{
  home.file.".zshrc".source = zshrc;
}
