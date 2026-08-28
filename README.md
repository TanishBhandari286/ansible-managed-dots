# dots — Personal Dotfiles & Infrastructure as Code

One repo, one provisioning tool: **Ansible**, targeting both platforms.

- **macOS** → Ansible + Homebrew (`brew bundle`). See `ansible/playbooks/mac.yml`.
- **Linux servers/VPS** → Ansible + Homebrew. See `ansible/playbooks/linux.yml`.

macOS was once provisioned by nix-darwin + home-manager — it isn't anymore. Ansible + Homebrew owns both platforms now.

---

## macOS

One command, works whether you're the owner (SSH keys decrypt automatically) or a stranger trying the setup:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/install.sh)"
```

This installs Homebrew (if missing), installs all brews/casks/taps from `.config/Brewfile` via `brew bundle`, installs Node/Go via mise, applies macOS system defaults, decrypts SSH keys with Ansible Vault, and symlinks the dotfiles. Update anytime with the `macupdate` shell alias (runs `ansible-playbook playbooks/mac.yml`).

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
| Shell | zsh, starship, zsh-syntax-highlighting, zsh-autosuggestions, fzf |
| Core replacements | eza (ls), bat (cat), fd (find), ripgrep (grep), zoxide (cd) |
| Editor | Neovim (LazyVim) |
| Git | git, lazygit, delta |
| Runtimes | mise (polyglot version manager), node@22, Python 3.14 |
| Containers | Docker, lazydocker |
| Theme | Tokyo Night (Storm) — zsh colors, fzf, and the Ghostty terminal all match |

Everything with upstream releases is pulled from the **latest Homebrew release**, not the OS package manager — apt's versions of things like ripgrep/fd/bat/neovim lag behind, so brew is used for those directly. Only genuinely stable/base packages (curl, git, build-essential, etc.) come from apt on Linux; on macOS, Homebrew plays that role and tracks upstream closely on its own.

## Repo layout

```
.zshrc                    # cross-platform shell config (symlinked on both)
.config/Brewfile          # macOS: single source of truth for brews/casks/taps
.config/                  # App configs symlinked on both platforms (nvim, ghostty, ...)
ansible/
  playbooks/mac.yml       #   macOS provisioning (brew bundle + defaults + vault)
  playbooks/linux.yml     #   Linux provisioning
  roles/                  #   packages, shell, node, docker, ssh, dotfiles
ssh_keys/                 # SSH keys, encrypted at rest with Ansible Vault
```

## Secrets

SSH private keys live in `ssh_keys/id_*` (no extension), encrypted with **Ansible Vault**. The vault password file is `ansible/.vault_pass` (gitignored). `.pub` files are committed in plaintext. Everything is decryptable with `ansible-vault view`.
