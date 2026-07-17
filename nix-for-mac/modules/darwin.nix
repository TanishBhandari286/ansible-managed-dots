# ── darwin.nix ─────────────────────────────────────────────────────────
# nix-darwin entry point. Imports system sub-modules and home-manager.
# Replaces the old Ansible mac.yml + roles/packages/tasks/darwin.yml.
{ config, lib, pkgs, username, dotsPath, ... }:

{
  imports = [
    ./system/packages.nix
    ./system/homebrew.nix
    ./system/defaults.nix
    ./home-manager.nix
  ];

  system.stateVersion = 7;
  system.primaryUser = username;

  nix.enable = false;  # managed by Determinate Nix installer
}
