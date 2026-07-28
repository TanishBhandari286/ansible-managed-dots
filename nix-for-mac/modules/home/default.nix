# ── home/default.nix ───────────────────────────────────────────────────
# Entry point for home-manager user modules.
{
  imports = [
    ./files.nix
    ./zsh.nix
    ./programs.nix
    ./npm-globals.nix
  ];

  home.stateVersion = "24.11";
}
