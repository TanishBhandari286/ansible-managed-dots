{
  description = "macOS dotfiles — nix-darwin + home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager }:
  let
    dotsPath = ../.;
    rawUser = builtins.getEnv "NIX_USER";
    username = if rawUser != "" then rawUser else "devops";
    rawHost = builtins.getEnv "NIX_HOST";
    hostname = if rawHost != "" then rawHost else "devopss-MacBook-Air";
  in {
    darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      specialArgs = { inherit username dotsPath; };
      modules = [
        ./modules/darwin.nix
        home-manager.darwinModules.home-manager
      ];
    };
  };
}
