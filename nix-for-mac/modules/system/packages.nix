# ── packages.nix ───────────────────────────────────────────────────────
# CLI tools installed via nixpkgs (system-wide).
#
# Kept minimal on purpose: nixpkgs' aarch64-darwin binary cache has far
# fewer prebuilt bottles than Homebrew's, so anything not covered here
# ends up compiling from source on this machine. Everything Homebrew
# already bottles for Apple Silicon lives in homebrew.nix's `brews`
# instead -- this file only holds `nil`, which Homebrew doesn't package.
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nil # Nix LSP -- no Homebrew formula exists
  ];
}
