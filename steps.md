# Steps & Command Reference

A chronological log of every structural change made to this repository and every command you need to run to bootstrap or maintain it.

---

## Phase 1 — Initial Setup (Run Once)

### 1.1 Install Xcode Command Line Tools (macOS)

```bash
xcode-select --install
```

> Follow the GUI prompt. Skip if already installed.

### 1.2 Install Ansible on macOS Control Node

```bash
pip3 install --user ansible
# Verify installation
ansible --version
```

### 1.3 Clone the Dotfiles Repository

```bash
git clone https://github.com/tanishbhandari286/dots.git ~/dots
```

### 1.4 Install Required Ansible Collections

```bash
cd ~/dots/ansible
ansible-galaxy collection install -r requirements.yml
```

Collections installed:
- `ansible.posix` ≥ 1.5.0 — provides `authorized_key` module
- `community.general` ≥ 8.0.0 — supplementary modules

---

## Phase 2 — Vault & Secret Management (Run Once Per Machine)

### 2.1 Create the Vault Password File

```bash
# Create the file — use a strong, unique password
echo "your-strong-vault-password" > ~/dots/ansible/.vault_pass
chmod 600 ~/dots/ansible/.vault_pass
```

> **Critical:** This file is in `.gitignore`. It MUST be recreated manually on every new machine.

### 2.2 Encrypt Your Private SSH Keys

Run these from the root of the repo (`~/dots`):

```bash
cd ~/dots

ansible-vault encrypt ssh_keys/id_ed25519_sk_key1 \
  --vault-password-file ansible/.vault_pass

ansible-vault encrypt ssh_keys/id_ed25519_sk_key2 \
  --vault-password-file ansible/.vault_pass

ansible-vault encrypt ssh_keys/id_ed25519_sk_key3 \
  --vault-password-file ansible/.vault_pass

ansible-vault encrypt ssh_keys/id_ed25519_sk_key4 \
  --vault-password-file ansible/.vault_pass
```

### 2.3 Verify Encryption Worked

```bash
# Should print: $ANSIBLE_VAULT;1.1;AES256
head -1 ssh_keys/id_ed25519_sk_key1
```

### 2.4 Decrypt a Key for Inspection (Optional)

```bash
# View decrypted content without writing to disk
ansible-vault view ssh_keys/id_ed25519_sk_key1 \
  --vault-password-file ansible/.vault_pass
```

### 2.5 Re-encrypt a Key (if you need to rotate)

```bash
# Decrypt in-place first, then re-encrypt with new password
ansible-vault decrypt ssh_keys/id_ed25519_sk_key1 \
  --vault-password-file ansible/.vault_pass

ansible-vault encrypt ssh_keys/id_ed25519_sk_key1 \
  --vault-password-file ansible/.vault_pass
```

### 2.6 Commit Encrypted Keys to Git

```bash
cd ~/dots
git add ssh_keys/
git add .gitignore .zshrc README.md ansible/ git/
git commit -m "feat: add ansible infrastructure with encrypted SSH keys"
git push
```

---

## Phase 3 — macOS Provisioning

### 3.1 Full macOS Provision

```bash
cd ~/dots/ansible
ansible-playbook playbooks/mac.yml --vault-password-file .vault_pass
```

Runs in order: **Homebrew → shell (Zsh) → dotfiles symlinks → SSH keys**

### 3.2 Run Specific Roles via Tags

```bash
# Homebrew / Brewfile only
ansible-playbook playbooks/mac.yml --vault-password-file .vault_pass --tags brew

# Shell + Zsh only
ansible-playbook playbooks/mac.yml --vault-password-file .vault_pass --tags shell

# Dotfiles symlinks only
ansible-playbook playbooks/mac.yml --vault-password-file .vault_pass --tags dotfiles

# SSH keys only
ansible-playbook playbooks/mac.yml --vault-password-file .vault_pass --tags ssh
```

### 3.3 Dry Run (Check Mode — No Changes Applied)

```bash
ansible-playbook playbooks/mac.yml --vault-password-file .vault_pass \
  --check --diff
```

---

## Phase 4 — Linux Provisioning

### 4.1 Add Linux Hosts to Inventory

Edit `ansible/inventory/hosts.ini`:

```ini
[linux]
vps    ansible_host=69.62.77.27  ansible_user=devops
node-1 ansible_host=192.168.1.11 ansible_user=ubuntu
node-2 ansible_host=192.168.1.12 ansible_user=ubuntu
```

### 4.2 Test SSH Connectivity

```bash
cd ~/dots/ansible
ansible linux -m ping
```

### 4.3 Full Linux Provision (All Hosts)

```bash
ansible-playbook playbooks/linux.yml \
  --vault-password-file .vault_pass \
  --ask-become-pass
```

### 4.4 Provision a Single Host

```bash
ansible-playbook playbooks/linux.yml \
  -l vps \
  --vault-password-file .vault_pass \
  --ask-become-pass
```

### 4.5 Selective Linux Tags

```bash
# Packages only
ansible-playbook playbooks/linux.yml --vault-password-file .vault_pass \
  --ask-become-pass --tags packages

# Inject authorized_keys only
ansible-playbook playbooks/linux.yml --vault-password-file .vault_pass \
  --ask-become-pass --tags ssh

# Dotfiles symlinks only
ansible-playbook playbooks/linux.yml --vault-password-file .vault_pass \
  --ask-become-pass --tags dotfiles
```

---

## Phase 5 — Bootstrapping a Brand-New Machine (Summary)

```bash
# 1. Clone
git clone https://github.com/<your-username>/dots.git ~/dots

# 2. Install Ansible
pip3 install --user ansible          # macOS
sudo apt install ansible -y          # Ubuntu/Debian

# 3. Install collections
cd ~/dots/ansible
ansible-galaxy collection install -r requirements.yml

# 4. Recreate vault password file
echo "your-vault-password" > ~/dots/ansible/.vault_pass
chmod 600 ~/dots/ansible/.vault_pass

# 5. Run appropriate playbook
# macOS:
ansible-playbook playbooks/mac.yml --vault-password-file .vault_pass
# Linux:
ansible-playbook playbooks/linux.yml --vault-password-file .vault_pass --ask-become-pass
```

---

## Structural Changes Log

| Date | Change |
|---|---|
| 2026-06-17 | Initial commit: raw config files (starship.toml, .config/, ssh_keys/, git/) |
| 2026-06-17 | Added Ansible infrastructure: ansible.cfg, inventory, group_vars, playbooks, roles |
| 2026-06-17 | Added `.zshrc` (minimal clean config with Starship, fzf, Homebrew path handling) |
| 2026-06-17 | Added `README.md`, `.gitignore`, `steps.md` |
| 2026-06-17 | Created roles: homebrew, shell, dotfiles_mac, dotfiles_linux, packages_linux, ssh_mac, ssh_linux |

---

## Troubleshooting

### "vault password file not found"

```bash
ls -la ~/dots/ansible/.vault_pass
# If missing, recreate it:
echo "your-password" > ~/dots/ansible/.vault_pass
chmod 600 ~/dots/ansible/.vault_pass
```

### "Decryption failed" on SSH keys

The key is encrypted but the vault password is wrong. Verify the password and try again. Do NOT commit unencrypted keys.

### "brew: command not found" after Homebrew install

```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"
# Intel
eval "$(/usr/local/bin/brew shellenv)"
```

### ansible.posix not found

```bash
ansible-galaxy collection install ansible.posix
```

### Check symlinks are correct

```bash
ls -la ~/.zshrc ~/.gitconfig ~/.config/nvim ~/.config/starship.toml
# Should show -> ~/dots/...
```
