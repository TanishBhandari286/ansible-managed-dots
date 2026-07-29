# ── homebrew.nix ───────────────────────────────────────────────────────
# GUI apps and non-nixpkgs formulae via Homebrew.
{ config, ... }:

{
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";

    # All of these are third-party taps, so Homebrew 6+'s HOMEBREW_REQUIRE_TAP_TRUST
    # refuses to load their formulae/casks unless explicitly marked trusted here.
    taps = [
      { name = "nikitabobko/tap"; trusted = true; }
      { name = "barutsrb/tap"; trusted = true; }
      { name = "can1357/tap"; trusted = true; }
      { name = "tw93/tap"; trusted = true; }
    ];

    brews = [
      "sshs"
      "portal"
      "omp"
      "mole"
      "rust" # provides cargo + rustc
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
