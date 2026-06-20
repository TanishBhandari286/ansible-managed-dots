# dots — Personal Dotfiles & Infrastructure as Code

A fully automated, Ansible-powered dotfiles repository for macOS workstations and Linux servers.

---

## Public Installation (Strangers)

If you'd like to use this setup, you can install it with a single command. This public mode will install all packages, applications, and dotfiles symlinks, but it will safely skip the private SSH keys and Ansible Vault secrets.

**For macOS:**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/bootstrap-public-mac.sh)"
```

**For Linux:**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/bootstrap-public-linux.sh)"
```

### What this will install:

**Command Line Tools (Mac & Linux)**:
`zsh`, `git`, `neovim`, `tmux`, `starship` (prompt), `eza` (modern `ls`), `bat` (modern `cat`), `fzf` (fuzzy finder), `ripgrep`, `fd`, `htop`, `python3`, `node.js`, `docker` (Linux only).

**Mac Applications (Casks)**:
`Ghostty` (terminal), `AeroSpace` (tiling window manager), `OrbStack` (Docker replacement), `VS Code`, `Obsidian`, `Raycast`, `Brave Browser`, `Proton Suite` (Mail, VPN, Drive, Pass), `Spotify`, `Stremio`, `WhatsApp`.

### What this will do:
- Ask for your `sudo` password upfront to authorize installations.
- Keep the `sudo` credential alive in the background so you are never prompted again.
- Automatically install Xcode CLI tools, Homebrew, and Ansible (if missing).
- Clone this repository to `~/dots`.
- Automatically bypass the owner's Ansible Vault requirements.
- Run the public Ansible playbook (`public-mac.yml` or `public-linux.yml`) to symlink dotfiles and install packages.

---

## Personal Use (Owner)

**For macOS (Local Setup):**
To bootstrap a brand new Mac out of the box:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/bootstrap.sh)"
```
*(If already cloned and you just want to run updates, run: `cd ~/dots/ansible && ansible-playbook playbooks/mac.yml`)*

**For Linux (Remote Provisioning):**
Edit `ansible/inventory/hosts.ini` to add your server IPs, then run:
```bash
cd ~/dots/ansible
ansible-playbook -i inventory/hosts.ini playbooks/linux.yml
```
*(Note: Use `-K` to prompt for sudo password if your remote user requires it for privilege escalation).*
