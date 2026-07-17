# ── defaults.nix ───────────────────────────────────────────────────────
# macOS system defaults (Dock, Finder, Keyboard, Screenshots).
# No trackpad settings — trackpad preferences are managed in System Settings.
{ config, ... }:

{
  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      orientation = "bottom";
    };

    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };

    screencapture.location = "~/Pictures/Screenshots";
  };

  nixpkgs.config.allowUnfree = true;
}
