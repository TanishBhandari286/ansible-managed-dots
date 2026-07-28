# ── home/npm-globals.nix ───────────────────────────────────────────────
# npm-installed global CLIs that aren't packaged in nixpkgs.
{ pkgs, lib, ... }:

{
  home.activation.installCommandCode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    verboseEcho "Installing/updating command-code (coding agent) via npm"
    run "${pkgs.nodejs_22}/bin/npm" install -g command-code@latest --silent
  '';
}
