# Taste (Continuously Learned by [CommandCode][cmd])

[cmd]: https://commandcode.ai/

- Prefer being shown planned changes and expected version/outcome information *before* execution — "do not run, just update and then tell me which software gets which version." Confidence: 0.80
- Prefer language-ecosystem version managers (e.g., mise) over system package managers (e.g., apt) for developer tooling like Node.js. Confidence: 0.75
- Shell-rc dotfiles must include initialization for all version managers and CLI tools installed by playbooks (e.g., `mise activate zsh` in `.zshrc`). Tools should work immediately in the user's configured login shell without requiring manual fixes after provisioning. Confidence: 0.70
- Prefer upgrading CLI tools to their absolute latest version rather than staying on the LTS-bundled default. When a tool like npm itself notifies about a newer major version, upgrade to it — don't settle for "this is what ships with Node 22 LTS." Confidence: 0.80
- When applying a fix or upgrade to a managed machine, apply it both immediately (live, via SSH) and codify it in the automation playbook for future reproducibility. "Fix it now AND fix it forever" — never leave the playbook stale while patching the live system. Confidence: 0.85
