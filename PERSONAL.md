# Personal Setup

For the repo owner — you hold `ansible/.vault_pass` and the vault-encrypted keys in `ssh_keys/`. Running the same entry points below unlocks the owner-only steps that a stranger's run skips.

## What you get beyond the public setup

- Your real SSH keys — `id_ed25519_ansible` (automation) and your FIDO2 keys — decrypted into `~/.ssh`
- Your git identity from `~/.gitconfig.local`
- On Linux: the actual inventoried hosts (`vps`, `master-node`, `cp`, `dp`) get provisioned, not just the machine you're sitting at
- The `ssh` role: GitHub's host key pinned, automation key deployed to every server so future `dotfiles` pulls need no password

## macOS

Drop your vault password into `~/dots/ansible/.vault_pass` first if you haven't already — SSH keys only decrypt automatically when that's in place:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/bootstrap-mac.sh)"
```

This installs Homebrew and Ansible if either is missing, clones the repo, then runs `ansible-playbook playbooks/mac.yml` — which does everything below plus an explicit `brew update` before `brew bundle`, so you're never installing against a stale package index. Update anytime with the `macupdate` shell alias.

CLI tools:

| Package | What it is |
|---|---|
| `python@3.14` | Python interpreter |
| `tree` | Directory listings as a tree |
| `ansible` | Automation/config management — provisions this very repo |
| `bat` | `cat` with syntax highlighting and git integration |
| `bottom` | Graphical process/system monitor |
| `bun` | Fast all-in-one JS runtime, bundler, and package manager |
| `cmake` | Cross-platform build system |
| `eza` | Modern `ls` replacement |
| `fd` | Fast, friendly `find` replacement |
| `fzf` | Command-line fuzzy finder |
| `git` | Version control |
| `git-delta` | Nicer diffs for git and `less` |
| `htop` | Interactive process viewer |
| `lazydocker` | Terminal UI for Docker |
| `lazygit` | Terminal UI for git |
| `libomp` | LLVM's OpenMP runtime library |
| `mise` | Polyglot runtime manager — installs Node/Go below |
| `mole` | Deep clean / disk-space optimizer for macOS |
| `tree-sitter` | Incremental parsing library (used by Neovim) |
| `neovim` | Editor, running the LazyVim distro |
| `openssh` | SSH connectivity tools |
| `pnpm` | Fast, disk-space-efficient JS package manager |
| `portal` | Command-line file transfer between machines |
| `ripgrep` | Very fast recursive `grep` |
| `rust` | Rust toolchain |
| `sshs` | Terminal UI for managing SSH connections |
| `starship` | Cross-shell prompt |
| `tmux` | Terminal multiplexer |
| `topgrade` | Upgrades everything (brew, npm, rustup, ...) in one command |
| `uv` | Extremely fast Python package installer/resolver |
| `wget` | File downloader |
| `zoxide` | `cd` that learns your habits |
| `zsh-autosuggestions` | Fish-style command autosuggestions for zsh |
| `zsh-completions` | Extra completion definitions for zsh |
| `zsh-syntax-highlighting` | Fish-style syntax highlighting for zsh |

Apps (casks):

| Package | What it is |
|---|---|
| `aerospace` | i3-like tiling window manager |
| `brave-browser` | Privacy-focused browser |
| `font-jetbrains-mono` | JetBrains Mono monospace font |
| `gcloud-cli` | Google Cloud SDK |
| `ghostty` | GPU-accelerated terminal emulator |
| `iina` | Media player |
| `obs` | Screen recording / live streaming |
| `obsidian` | Markdown knowledge base |
| `omniwm` | Niri-inspired column-based tiling window manager |
| `orbstack` | Docker Desktop replacement |
| `raycast` | Launcher / productivity app |
| `syncthing-app` | Peer-to-peer file sync |
| `visual-studio-code` | Code editor |
| `whatsapp` | Desktop WhatsApp client |
| `macshot` | Screenshot / screen recording tool |
| `trex` | Regex-based text extraction tool |
| `zap` | OWASP ZAP — web app security scanner |

Plus: Node 22 and Go installed via `mise`, `gopls` via `go install`, and `eslint`/`tree-sitter-cli` as npm globals. VS Code extensions (Python, Docker, Kubernetes, remote-SSH, themes) install from the same Brewfile.

## Linux (servers / VPS)

Edit `ansible/inventory/hosts.ini` with your host(s), then:

```bash
cd ~/dots/ansible
ansible-playbook -i inventory/hosts.ini playbooks/linux.yml
```

Or just run the `linuxansible` shell alias if the repo's already cloned. This is the only path that deploys real secrets — only point it at boxes you own.

**Homebrew (Linuxbrew) gets installed first**, running as your normal user — never as root — since Linux doesn't ship it.

Via Homebrew:

| Package | What it is |
|---|---|
| `zsh` | The shell itself |
| `git` | Version control |
| `curl` | Transfer data from a URL |
| `wget` | File downloader |
| `unzip` | Extracts `.zip` archives |
| `tmux` | Terminal multiplexer |
| `htop` | Interactive process viewer |
| `tree` | Directory listings as a tree |
| `neovim` | Editor, running the LazyVim distro |
| `eza` | Modern `ls` replacement |
| `ripgrep` | Very fast recursive `grep` |
| `fd` | Fast, friendly `find` replacement |
| `bat` | `cat` with syntax highlighting and git integration |
| `lazydocker` | Terminal UI for Docker |
| `lazygit` | Terminal UI for git |
| `git-delta` | Nicer diffs for git and `less` |
| `starship` | Cross-shell prompt |
| `zoxide` | `cd` that learns your habits |
| `mise` | Polyglot runtime manager — installs Node 22 |
| `fzf` | Command-line fuzzy finder |
| `zsh-syntax-highlighting` | Fish-style syntax highlighting for zsh |
| `zsh-autosuggestions` | Fish-style command autosuggestions for zsh |
| `zsh-completions` | Extra completion definitions for zsh |
| `python@3.14` | Python interpreter |

Via apt (things brew doesn't own on Linux):

| Package | What it is |
|---|---|
| `build-essential` | C/C++ compiler toolchain |
| `docker-ce`, `docker-ce-cli`, `containerd.io` | Docker Engine |
| `docker-buildx-plugin` | BuildKit-powered `docker build` |
| `docker-compose-plugin` | `docker compose` |

Plus Node 22 via `mise`.
