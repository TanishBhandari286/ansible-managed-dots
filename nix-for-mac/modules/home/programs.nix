# ── home/programs.nix ──────────────────────────────────────────────────
# Home-manager programs modules (direnv, htop, etc.)
{ config, ... }:

{
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    htop.enable = true;
  };
}
