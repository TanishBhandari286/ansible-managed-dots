# ── home/npm-globals.nix ───────────────────────────────────────────────
# npm-installed global CLIs that aren't packaged in nixpkgs.
{ lib, ... }:

{
  home.activation.installCommandCode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    verboseEcho "Installing/updating command-code (coding agent) via npm"
    # command-code's deps (e.g. protobufjs) run a postinstall step that shells
    # out to bare `node` -- the activation script's PATH is minimal and won't
    # have it otherwise. node@22 is a Homebrew keg-only formula, so it isn't
    # on the default Homebrew PATH either.
    PATH="/opt/homebrew/opt/node@22/bin:$PATH" run "/opt/homebrew/opt/node@22/bin/npm" install -g command-code@latest --silent
  '';
}
