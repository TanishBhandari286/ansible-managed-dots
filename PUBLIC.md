# Public Setup

Trying this out on your own machine — no vault password, no keys, nothing owner-specific gets touched.

## What you get

- Your own dotfiles symlinked from this repo — the owner's `ssh_keys/` stay vault-encrypted and untouched without the password
- Every CLI tool and app listed below, identical to what the owner gets
- Tokyo Night theme across shell, fzf, and tmux

## macOS

Same command the owner uses — Homebrew, all the tools, and the dotfiles install identically either way. You just don't have the vault password, so the SSH-key-decrypt step skips itself automatically:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/install.sh)"
```

**Homebrew itself gets installed first** if it isn't already on the machine — everything below is `brew bundle`'d from `.config/Brewfile` in one shot.

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

## Linux

Dedicated public path — installs Ansible, clones this repo over HTTPS, and runs a playbook with no vault dependency at all:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/bootstrap-public-linux.sh)"
```

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
