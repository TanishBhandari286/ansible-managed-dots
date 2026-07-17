# ── home-manager.nix ───────────────────────────────────────────────────
# Wires home-manager into nix-darwin.  Used by flake.nix.
{ config, lib, username, dotsPath, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "nix-bak";
    extraSpecialArgs = { inherit dotsPath username; };
    users.${username} = {
      home.homeDirectory = lib.mkForce "/Users/${username}";
      imports = [
        ./home/default.nix
      ];
    };
  };
}
