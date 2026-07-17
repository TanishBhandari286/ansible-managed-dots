# ── homebrew.nix ───────────────────────────────────────────────────────
# GUI apps and non-nixpkgs formulae via Homebrew.
{ config, ... }:

{
  homebrew = {
    enable = true;
    onActivation.cleanup = "none";

    taps = [
      "nikitabobko/tap"
      "barutsrb/tap"
      "can1357/tap"
      "tw93/tap"
    ];

    brews = [
      "can1357/tap/omp"
      "tw93/tap/mole"
      "sshs"
      "portal"
      "omp"
    ];

    casks = [
      "ghostty"
      "barutsrb/tap/omniwm"
      "aerospace"
      "antigravity"
      "brave-browser"
      "font-jetbrains-mono"
      "gcloud-cli"
      "helium-browser"
      "iina"
      "obs"
      "obsidian"
      "orbstack"
      "raycast"
      "syncthing-app"
      "visual-studio-code"
      "whatsapp"
      "zap"
      "zed"
    ];

    masApps = { };
  };
}
