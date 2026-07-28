# ── homebrew.nix ───────────────────────────────────────────────────────
# GUI apps and non-nixpkgs formulae via Homebrew.
{ config, ... }:

{
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";

    taps = [
      "nikitabobko/tap"
      "barutsrb/tap"
      "can1357/tap"
      "tw93/tap"
    ];

    brews = [
      "sshs"
      "portal"
      "omp"
      "mole"
    ];

    casks = [
      "ghostty"
      "barutsrb/tap/omniwm"
      "aerospace"
      "antigravity"
      "brave-browser"
      "claude-code"
      "font-jetbrains-mono"
      "gcloud-cli"
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
      "firefox"
    ];

    masApps = { };
  };
}
