# ── home/npm-globals.nix ───────────────────────────────────────────────
# npm-installed global CLIs that aren't packaged in nixpkgs.
{ pkgs, lib, ... }:

{
  home.activation.installCommandCode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    verboseEcho "Installing/updating command-code (coding agent) via npm"
    # command-code's deps (e.g. protobufjs) run a postinstall step that shells
    # out to bare `node` — the activation script's PATH is minimal and won't
    # have it otherwise.
    PATH="${pkgs.nodejs_22}/bin:$PATH" run "${pkgs.nodejs_22}/bin/npm" install -g command-code@latest --silent
  '';
}
