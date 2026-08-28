# Public Setup

Trying this out on your own machine — no vault password, no keys, nothing owner-specific gets touched.

## What you get

- Zsh + Starship + fzf + eza/bat/fd/ripgrep/zoxide
- Neovim (LazyVim)
- Docker (Linux only)
- Node 22 via mise
- Tokyo Night theme across shell, fzf, and tmux
- Your own dotfiles symlinked from this repo — the owner's `ssh_keys/` stay vault-encrypted and untouched without the password

## macOS

Same command the owner uses — Homebrew, all the tools, and the dotfiles install identically either way. You just don't have the vault password, so the SSH-key-decrypt step skips itself automatically:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/install.sh)"
```

## Linux

Dedicated public path — installs Ansible, clones this repo over HTTPS, and runs a playbook with no vault dependency at all:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/bootstrap-public-linux.sh)"
```
