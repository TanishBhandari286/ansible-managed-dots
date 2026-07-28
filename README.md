# dots — Personal Dotfiles & Infrastructure as Code

One repo, two provisioning tools, split by platform:

- **macOS** → [Nix](https://nixos.org) (`nix-darwin` + `home-manager`), fully declarative. See [`nix-for-mac/nix.md`](nix-for-mac/nix.md) for the deep dive.
- **Linux servers/VPS** → [Ansible](https://www.ansible.com/), in [`ansible/`](ansible).

macOS used to be provisioned by Ansible too — it isn't anymore. Nix owns the Mac entirely now; the Ansible side only targets Linux.

---

## macOS

One command, works whether you're the owner (SSH keys decrypt automatically) or a stranger trying the setup:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/nix-for-mac/bootstrap.sh)"
```

Not the owner? Set your own user/host first so it doesn't try to use mine:

```bash
NIX_USER=alice NIX_HOST=alices-macbook bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/nix-for-mac/bootstrap.sh)"
```

This installs Xcode CLI tools, Nix, Homebrew (for GUI apps Nix doesn't package), clones the repo, and builds the whole system. Update anytime with the `macupdate` shell alias.

## Linux (servers / VPS)

**Personal use** — edit `ansible/inventory/hosts.ini` with your host(s), then:

```bash
cd ~/dots/ansible
ansible-playbook -i inventory/hosts.ini playbooks/linux.yml
```

Or just run the `linuxansible` shell alias if the repo's already cloned.

**Public mode** (strangers, no vault secrets) — one command:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/bootstrap-public-linux.sh)"
```

---

## What you get

| Category | Tools |
|---|---|
| Shell | zsh, spaceship-prompt, zsh-syntax-highlighting, zsh-autosuggestions, fzf |
| Core replacements | eza (ls), bat (cat), fd (find), ripgrep (grep), zoxide (cd) |
| Editor | Neovim (LazyVim) |
| Git | git, lazygit, delta |
| Runtimes | mise (polyglot version manager), nvm + Node (Linux) / nixpkgs Node (Mac), Python 3.14 |
| Containers | Docker, lazydocker |
| Coding agents | [omp](https://omp.sh) (oh-my-pi), [command-code](https://commandcode.ai) |
| Theme | Tokyo Night (Storm) — zsh colors, fzf, and the Ghostty terminal all match |

Everything with upstream releases is pulled from the **latest GitHub release**, not the OS package manager — apt's versions of things like ripgrep/fd/bat/neovim lag behind, so those are fetched directly instead. Only genuinely stable/base packages (curl, git, build-essential, etc.) come from apt on Linux; on Mac, nixpkgs plays that role and tracks upstream closely on its own.

## Repo layout

```
.zshrc                   # Linux shell config (symlinked by ansible/roles/dotfiles)
nix-for-mac/              # Everything macOS — nix-darwin + home-manager
  bootstrap.sh            #   one-shot Mac setup script
  modules/zshrc.template  #   Mac shell config (Nix-templated equivalent of .zshrc)
  nix.md                  #   full reference: what's installed, how to add/remove things
ansible/                  # Everything Linux
  playbooks/linux.yml     #   the only playbook that matters now
  roles/                  #   packages, node, docker, ssh, dotfiles
.config/                  # App configs symlinked on both platforms (nvim, ghostty, ...)
ssh_keys/                 # SSH keys, encrypted at rest with sops (age)
```

## Secrets

SSH private keys live in `ssh_keys/*.enc`, encrypted with [sops](https://github.com/getsops/sops) + [age](https://github.com/FiloSottile/age). Ansible Vault handles other secrets under `ansible/group_vars/all/vault.yml`. Neither is readable without the corresponding key/password — see `nix-for-mac/nix.md` for the sops setup if you're forking this.
