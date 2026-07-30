# ── home/programs.nix ──────────────────────────────────────────────────
# Home-manager programs modules (direnv, htop, etc.)
#
# direnv/htop stay on nixpkgs rather than moving to Homebrew like the rest
# of packages.nix: `programs.direnv` is what wires up nix-direnv's flake
# caching, and both packages are small/fast to build, so there's nothing
# to gain by migrating them (and doing so would just fight this module
# for which binary wins on PATH).
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
