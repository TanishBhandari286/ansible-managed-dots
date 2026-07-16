# nix
- Prefer referencing original dotfiles via home.file.*.source instead of inlining config into Nix strings like xdg.configFile.*.text. Confidence: 0.85
- Maintain both Ansible and Nix provisioning paths; don't delete Ansible playbooks or roles even though Nix is the primary path. Confidence: 0.80
- Use sops-nix for SSH key and secrets management. Confidence: 0.75
- Use pkgs.replaceVars (not substituteAll) for template variable substitution — substituteAll has been removed from nixpkgs. Confidence: 0.85
- Make flake portable via builtins.getEnv for NIX_USER/NIX_HOST with --impure flag, so any macOS user can build without editing Nix source. Confidence: 0.80
- Keep personal configs (git user, SSH hosts) in .local override files sourced from the shared config, never hardcode personal values in repo-tracked files. Confidence: 0.80
