# Using This Dotfiles Repo — Guide for Friends & Colleagues

Everything here — Neovim, Zsh, Starship, .gitconfig, AeroSpace, Ghostty (macOS), and
Docker (Linux) — can be on your machine in a single command.

**You do not need:** a vault password, any SSH keys, or any Ansible experience.

---

## What you get

| Config | macOS | Linux |
|---|---|---|
| Zsh + `.zshrc` (history, completions, aliases) | ✅ | ✅ |
| Neovim config | ✅ | ✅ |
| `.gitconfig` | ✅ | ✅ |
| Starship prompt | ✅ | ✅ |
| Homebrew + Brewfile packages | ✅ | — |
| AeroSpace tiling WM config | ✅ | — |
| Ghostty terminal config | ✅ | — |
| Docker Engine (CE) | — | ✅ |
| Essential apt packages (git, fzf, ripgrep, tmux…) | — | ✅ |

**What you do NOT get** (skipped automatically):
- Personal SSH keys — these are private and encrypted; you wouldn't want them anyway
- FIDO2 key injection into `authorized_keys` — only relevant for the owner's servers

---

## macOS

### 1. Prerequisites (one-time)

```bash
# Install Xcode Command Line Tools (gives you git and python3)
xcode-select --install

# Install Ansible
pip3 install --user ansible

# Verify
ansible --version
```

### 2. Clone the repo

```bash
git clone https://github.com/TanishBhandari286/dots.git ~/dots
```

### 3. Install Ansible collections

```bash
cd ~/dots/ansible
ansible-galaxy collection install -r requirements.yml
```

### 4. Run — one command

```bash
cd ~/dots/ansible
ansible-playbook playbooks/mac.yml --skip-tags ssh
```

That's it. Ansible will:

1. Install Homebrew (if not already installed)
2. Run the Brewfile — installs all apps and CLI tools
3. Install Zsh and symlink `.zshrc` to `~/`
4. Symlink Neovim, AeroSpace, Ghostty, Starship configs into `~/.config/`
5. Symlink `.gitconfig` to `~/`

> **Note on AeroSpace / Ghostty:** If you haven't installed these apps yet,
> the symlinks will be created but the apps won't exist yet — that's fine.
> Install them afterwards and the config is already in place.

### Re-running (idempotent)

```bash
ansible-playbook playbooks/mac.yml --skip-tags ssh
```

A second run reports `changed=0` if nothing in the repo has changed.

### Selective runs

```bash
# Homebrew / Brewfile only
ansible-playbook playbooks/mac.yml --skip-tags ssh --tags brew

# Dotfiles symlinks only (no Homebrew)
ansible-playbook playbooks/mac.yml --skip-tags ssh --tags dotfiles

# Shell + Zsh only
ansible-playbook playbooks/mac.yml --skip-tags ssh --tags shell
```

---

## Linux (Ubuntu / Debian)

The Linux playbook is designed to target remote servers from a Mac control node.
To run it locally (on the same Ubuntu machine), use `localhost` as the target.

### 1. Prerequisites

```bash
# On the Ubuntu machine you want to provision:
sudo apt update
sudo apt install -y python3 ansible git

# Verify
ansible --version
```

### 2. Clone the repo

```bash
git clone https://github.com/TanishBhandari286/dots.git ~/dots
```

### 3. Install Ansible collections

```bash
cd ~/dots/ansible
ansible-galaxy collection install -r requirements.yml
```

### 4. Create a minimal local inventory

The default inventory targets remote servers. For running locally, override it:

```bash
cat > /tmp/local.ini << 'EOF'
[linux]
localhost ansible_connection=local ansible_user={{ lookup('env', 'USER') }}

[linux:vars]
ansible_python_interpreter=/usr/bin/python3
EOF
```

Or edit `ansible/inventory/hosts.ini` directly and add:

```ini
[linux]
localhost ansible_connection=local ansible_user=YOUR_USERNAME
```

Replace `YOUR_USERNAME` with the output of `whoami`.

### 5. Run — one command

```bash
cd ~/dots/ansible
ansible-playbook playbooks/linux.yml \
  -i /tmp/local.ini \
  --skip-tags ssh \
  --ask-become-pass
```

Enter your `sudo` password when prompted. Ansible will:

1. Update the apt cache
2. Install essential packages: zsh, git, curl, ripgrep, fzf, tmux, htop, neovim…
3. Install Zsh and set it as your default shell
4. Push `.zshrc` to `~/dots/.zshrc` and symlink to `~/`
5. Push Neovim config to `~/dots/.config/nvim/` and symlink to `~/.config/nvim`
6. Push `.gitconfig` and symlink to `~/`
7. Install Docker Engine via the official Docker apt repository
8. Add your user to the `docker` group
9. Verify Docker works with a hello-world container

### Re-running (idempotent)

```bash
ansible-playbook playbooks/linux.yml \
  -i /tmp/local.ini \
  --skip-tags ssh \
  --ask-become-pass
```

A second run reports `changed=0` if nothing changed.

### Selective runs

```bash
# Packages only
ansible-playbook playbooks/linux.yml -i /tmp/local.ini --ask-become-pass --tags packages

# Dotfiles only
ansible-playbook playbooks/linux.yml -i /tmp/local.ini --ask-become-pass --tags dotfiles

# Docker only
ansible-playbook playbooks/linux.yml -i /tmp/local.ini --ask-become-pass --tags docker

# Shell + Zsh only
ansible-playbook playbooks/linux.yml -i /tmp/local.ini --ask-become-pass --tags shell
```

---

## After provisioning

### Activate your new shell (Linux)

Docker group membership and the new default shell require a fresh login:

```bash
exec zsh   # or log out and back in
```

### Verify symlinks

```bash
ls -la ~/.zshrc ~/.gitconfig ~/.config/nvim
# Each should show -> ~/dots/...
```

### Verify Docker (Linux)

```bash
docker --version
docker compose version
docker run --rm hello-world
```

### Customise without touching the repo

Add a `~/.zshrc.local` file for machine-specific config (tokens, aliases, PATH
additions). The `.zshrc` sources it automatically and it is never committed.

```bash
echo 'export MY_TOKEN=abc123' >> ~/.zshrc.local
```

---

## Updating later

Pull new changes and re-run the playbook — it's fully idempotent:

```bash
cd ~/dots
git pull

# macOS
cd ansible && ansible-playbook playbooks/mac.yml --skip-tags ssh

# Linux
cd ansible && ansible-playbook playbooks/linux.yml \
  -i /tmp/local.ini --skip-tags ssh --ask-become-pass
```

---

## Troubleshooting

**`brew: command not found` after Homebrew installs**

```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"
# Intel
eval "$(/usr/local/bin/brew shellenv)"
```

**`ansible-galaxy: command not found`**

```bash
pip3 install --user ansible
export PATH="$HOME/.local/bin:$PATH"
```

**`permission denied` connecting to Docker socket (Linux)**

The docker group takes effect on the next login. Run:

```bash
exec zsh
docker run --rm hello-world
```

**`ansible.posix` collection not found**

```bash
ansible-galaxy collection install ansible.posix
```

**Symlinks point to `~/dots/` but the config files look like the owner's settings**

That's the point — you're running their exact config. Edit the files in `~/dots/`
directly (e.g. `~/dots/git/.gitconfig` to change your git name/email). The symlinks
mean your edits are live immediately.
