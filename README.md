# dots — Personal Dotfiles & Infrastructure as Code

A fully automated, Ansible-powered dotfiles repository for macOS workstations and Linux servers. Clone once, provision anywhere.

> **Friend or colleague?** See [STRANGER.md](STRANGER.md) for a single-command setup guide that skips the private key and vault stuff.

---

## Repository Structure

```
dots/
├── .gitconfig                  # Git configuration (symlinked to ~/.gitconfig)
├── .gitignore                  # Blocks private keys and vault password from git
├── .zshrc                      # Minimal Zsh configuration (symlinked to ~/.zshrc)
├── starship.toml               # Starship prompt config (symlinked to ~/.config/starship.toml)
├── README.md                   # Owner setup guide (this file)
├── STRANGER.md                 # One-command setup guide for friends / colleagues
├── steps.md                    # Chronological change log and command reference
│
├── .config/
│   ├── Brewfile                # Homebrew packages + casks (macOS only)
│   ├── aerospace/              # AeroSpace tiling WM config (macOS)
│   ├── ghostty/                # Ghostty terminal config (macOS)
│   └── nvim/                   # Neovim config (macOS + Linux)
│
├── git/
│   └── .gitconfig              # Git user configuration
│
├── ssh_keys/                   # FIDO2 SSH key pairs
│   ├── config                  # SSH client config
│   ├── id_ed25519_sk_key1      # Private key (ansible-vault encrypted)
│   ├── id_ed25519_sk_key1.pub  # Public key (plaintext, safe to commit)
│   ├── id_ed25519_sk_key2      # Private key (ansible-vault encrypted)
│   ├── id_ed25519_sk_key2.pub
│   ├── id_ed25519_sk_key3      # Private key (ansible-vault encrypted)
│   ├── id_ed25519_sk_key3.pub
│   ├── id_ed25519_sk_key4      # Private key (ansible-vault encrypted)
│   └── id_ed25519_sk_key4.pub
│
└── ansible/
    ├── ansible.cfg             # Ansible project settings
    ├── requirements.yml        # Galaxy collection dependencies
    │
    ├── inventory/
    │   └── hosts.ini           # Control node (mac) + Linux target hosts
    │
    ├── group_vars/
    │   └── all/
    │       ├── vars.yml        # Shared static variables (ssh_key_pairs)
    │       └── vault.yml       # Ansible-vault encrypted secrets
    │
    ├── playbooks/
    │   ├── mac.yml             # macOS provisioning playbook
    │   └── linux.yml           # Linux provisioning playbook
    │
    └── roles/
        ├── homebrew/           # Install Homebrew + run Brewfile
        ├── shell/              # Install Zsh (Linux) + symlink .zshrc
        ├── dotfiles_mac/       # macOS-specific config symlinks
        ├── dotfiles_linux/     # Linux-specific config symlinks
        ├── packages_linux/     # apt package installation
        ├── docker_linux/       # Docker Engine via official apt repository
        ├── ssh_mac/            # Deploy SSH keys + config to macOS
        └── ssh_linux/          # Inject public keys into authorized_keys
```

---

## Prerequisites

### macOS (Control Node)

```bash
# 1. Install Xcode Command Line Tools (required for git + python)
xcode-select --install

# 2. Install Ansible (via pip3 — before Homebrew exists)
pip3 install --user ansible

# 3. Clone this repository
git clone https://github.com/<your-username>/dots.git ~/dots

# 4. Install required Ansible collections
cd ~/dots/ansible
ansible-galaxy collection install -r requirements.yml
```

### Linux Targets

Linux targets only need:
- SSH access from the control node
- Python 3 installed (usually present by default on Ubuntu 20.04+)
- A user with `sudo` privileges

---

## First-Time Secret Setup (ansible-vault)

Before pushing to GitHub, **encrypt your private SSH keys**:

```bash
# Step 1: Create and store your vault password in a git-ignored file
echo "your-strong-vault-password" > ~/dots/ansible/.vault_pass
chmod 600 ~/dots/ansible/.vault_pass

# Step 2: Encrypt each private key
cd ~/dots
ansible-vault encrypt ssh_keys/id_ed25519_sk_key1 \
  --vault-password-file ansible/.vault_pass
ansible-vault encrypt ssh_keys/id_ed25519_sk_key2 \
  --vault-password-file ansible/.vault_pass
ansible-vault encrypt ssh_keys/id_ed25519_sk_key3 \
  --vault-password-file ansible/.vault_pass
ansible-vault encrypt ssh_keys/id_ed25519_sk_key4 \
  --vault-password-file ansible/.vault_pass

# Step 3: Verify a key is encrypted (should start with $ANSIBLE_VAULT;...)
head -1 ssh_keys/id_ed25519_sk_key1

# Step 4: Commit — .vault_pass is in .gitignore and will NOT be committed
git add ssh_keys/
git commit -m "feat: add encrypted FIDO2 SSH keys"
git push
```

> **On a new machine:** After cloning, recreate `.vault_pass` with the same password before running any playbook.

---

## Provisioning Commands

### macOS

```bash
cd ~/dots/ansible

# Full provision (Homebrew → shell → dotfiles → SSH keys)
ansible-playbook playbooks/mac.yml --vault-password-file .vault_pass

# Selective runs using tags
ansible-playbook playbooks/mac.yml --vault-password-file .vault_pass --tags brew
ansible-playbook playbooks/mac.yml --vault-password-file .vault_pass --tags dotfiles
ansible-playbook playbooks/mac.yml --vault-password-file .vault_pass --tags shell
ansible-playbook playbooks/mac.yml --vault-password-file .vault_pass --tags ssh
```

### Linux

```bash
cd ~/dots/ansible

# Edit inventory/hosts.ini first to add your server IPs, then:

# Full provision (packages → shell → dotfiles → Docker → authorized_keys)
ansible-playbook playbooks/linux.yml \
  --vault-password-file .vault_pass \
  --ask-become-pass

# Single host override
ansible-playbook playbooks/linux.yml \
  -l vps \
  --vault-password-file .vault_pass \
  --ask-become-pass

# Docker only
ansible-playbook playbooks/linux.yml \
  --vault-password-file .vault_pass \
  --ask-become-pass --tags docker

# Dry-run (check mode — no changes applied)
ansible-playbook playbooks/linux.yml \
  --vault-password-file .vault_pass \
  --check --diff
```

---

## Symlinking Strategy

All configuration files remain in this repository. Ansible creates symlinks from their canonical locations to the repo:

| Config File | Symlink Target |
|---|---|
| `.zshrc` | `~/.zshrc` |
| `git/.gitconfig` | `~/.gitconfig` |
| `starship.toml` | `~/.config/starship.toml` |
| `.config/nvim/` | `~/.config/nvim` |
| `.config/aerospace/` | `~/.config/aerospace` *(macOS only)* |
| `.config/ghostty/` | `~/.config/ghostty` *(macOS only)* |

Editing files in `~/dots` **is** editing your live config — no separate sync step needed.

---

## SSH Key Strategy

| File Type | macOS | Linux |
|---|---|---|
| Private keys (`id_ed25519_sk_*`) | ✅ Deployed to `~/.ssh/` | ❌ Never copied |
| Public keys (`*.pub`) | ✅ Deployed to `~/.ssh/` | ✅ Added to `authorized_keys` |
| SSH client `config` | ✅ Copied to `~/.ssh/config` | ❌ Not deployed |

Private keys are always encrypted with `ansible-vault` before being committed. The playbook decrypts them in memory during provisioning — they are never written to disk in plaintext anywhere other than your local `~/.ssh/`.

---

## Customization

### Adding a new Linux host

Edit `ansible/inventory/hosts.ini`:

```ini
[linux]
my-new-server ansible_host=10.0.0.5 ansible_user=ubuntu
```

### Adding or removing apt packages (Linux)

Edit `ansible/roles/packages_linux/defaults/main.yml` and modify the `linux_packages` list.

### Adding more SSH key pairs

1. Add the key files to `ssh_keys/`
2. Encrypt the private key: `ansible-vault encrypt ssh_keys/<keyname>`
3. Add the base name to `ssh_key_pairs` in `ansible/group_vars/all/vars.yml`

### Machine-local Zsh overrides

Add a `~/.zshrc.local` file (not committed to git) for secrets, tokens, or per-machine settings. `.zshrc` sources it automatically.

---

## Security Checklist

- [ ] Private keys are encrypted with `ansible-vault` before committing
- [ ] `.vault_pass` is listed in `.gitignore` (verify with `git check-ignore ansible/.vault_pass`)
- [ ] `~/.ssh/` directory has `700` permissions
- [ ] `~/.ssh/config` has `600` permissions
- [ ] Private key files in `~/.ssh/` have `600` permissions
- [ ] `no_log: true` is set on all tasks that handle private key content

---

## Friends & Colleagues

See **[STRANGER.md](STRANGER.md)** for a self-contained guide that:

- Uses `--skip-tags ssh` to skip all private key and vault operations
- Includes a local inventory trick so Linux can be run on the same machine without a separate control node
- Covers post-provisioning steps, troubleshooting, and how to update later
