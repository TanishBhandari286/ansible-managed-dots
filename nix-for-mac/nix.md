# Nix macOS Dotfiles

Fully declarative macOS setup powered by [nix-darwin][nd] + [home-manager][hm].
One command and your Mac is provisioned — every package, every config, every preference.
All rebuilds require `sudo` (nix-darwin + home-manager both operate at system level).

[nd]: https://github.com/LnL7/nix-darwin
[hm]: https://github.com/nix-community/home-manager

---

## Two paths — pick yours

### Path 1: If you're me (Tanish — has the keys)

I own the `age` private key at `~/.config/sops/age/keys.txt`, so SSH keys get decrypted automatically.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/nix-for-mac/bootstrap.sh)"
```

What this does for me that it won't do for others:
- Decrypts SSH keys from `ssh_keys/*.enc` via sops during bootstrap (step 8)

### Path 2: If you're not me (no keys)

Same bootstrap, but SSH key decryption will skip gracefully. You'll need to supply your own.

```bash
NIX_USER=alice NIX_HOST=alices-macbook bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/nix-for-mac/bootstrap.sh)"
```

After bootstrap, set up your identity:

**1. Git identity** — edit `~/.gitconfig.local`:
```
[user]
    name = Your Name
    email = you@example.com
```

**2. SSH keys** — generate and encrypt with sops:
```bash
age-keygen -o ~/.config/sops/age/keys.txt
# Add the public key to .sops.yaml in the age: section
ssh-keygen -t ed25519 -C "your@email.com" -f ~/.ssh/id_ed25519
cp ~/.ssh/id_ed25519 ~/dots/ssh_keys/
sops -e -i ~/dots/ssh_keys/id_ed25519
git add ~/dots/ssh_keys/id_ed25519.enc
```

**3. Customize** what's installed (see "Editing: which file does what" below).

---

## What the bootstrap installs

### CLI tools (via nixpkgs — system-wide)

| Category | What you get |
|----------|-------------|
| **Shell** | zsh, zsh-completions, zsh-autosuggestions, zsh-syntax-highlighting, tmux, starship |
| **Core replacements** | bat (cat), eza (ls), fd (find), ripgrep (grep), bottom (top), htop, tree |
| **Git ecosystem** | git, delta (diff viewer), lazygit, gh (GitHub CLI) |
| **Languages** | go + gopls, rustup, nodejs_22, bun, pnpm, python314, uv, cmake, llvm openmp |
| **DevOps** | lazydocker, ansible, age, wget, openssh |
| **Editor** | neovim, tree-sitter |
| **Navigation** | fzf, zoxide, mise |
| **System** | stow, topgrade, pkg-config, direnv, nil (Nix LSP), sops |

### GUI apps (via Homebrew casks)

| Category | What you get |
|----------|-------------|
| **Terminal** | Ghostty |
| **Window management** | OmniWM, Aerospace, AntiGravity |
| **Browsers** | Brave, Helium |
| **Dev tools** | VS Code, Zed, Orbstack, GCloud CLI |
| **Media** | IINA, OBS |
| **Productivity** | Obsidian, Raycast, Syncthing, WhatsApp, Zap |
| **Font** | JetBrains Mono |

### Homebrew formulae (CLI via brew)

`omp` (CommandCode CLI), `mole`, `sshs`, `portal`, plus taps for nikitabobko, barutsrb, can1357, tw93.

### macOS system defaults

| Area | Setting |
|------|---------|
| **Dock** | Auto-hide on, bottom, no MRU spaces |
| **Finder** | Show extensions, list view, path bar, status bar |
| **Keyboard** | Full keyboard access, key repeat = 2, delay = 15 |
| **Screenshots** | Saved to `~/Pictures/Screenshots` |

### User dotfiles (symlinked into home)

| Config | Destination |
|--------|------------|
| `.zshrc` | `~/.zshrc` (Nix-generated from template with store paths injected) |
| `.gitconfig` | `~/.gitconfig` (includes `~/.gitconfig.local` for personal details) |
| `starship.toml` | `~/.config/starship.toml` |
| Ghostty config | `~/.config/ghostty/config` |
| Aerospace | `~/.config/aerospace/aerospace.toml` |
| Neovim (LazyVim) | `~/.config/nvim/` |
| SSH config | `~/.ssh/config` |

### Programs configured by home-manager

- **direnv** — with nix-direnv integration
- **htop** — enabled via home-manager module

---

## Editing: which file does what

**To add/remove something, edit the file in the `Add/remove` column, then run `sudo darwin-rebuild switch --impure --flake ".#$NIX_HOST"`.**

| I want to… | Add/remove here | Details |
|------------|----------------|---------|
| Add/remove a CLI tool | `modules/system/packages.nix` | Add/remove from `environment.systemPackages` |
| Add/remove a GUI app | `modules/system/homebrew.nix` | Add/remove from `homebrew.casks` or `homebrew.brews` |
| Add a Homebrew tap | `modules/system/homebrew.nix` | Add to `homebrew.taps` |
| Change macOS defaults | `modules/system/defaults.nix` | Dock, Finder, keyboard, screenshots |
| Add/remove a dotfile symlink | `modules/home/files.nix` | `home.file.*` or `xdg.configFile.*` |
| Change zsh config | `modules/zshrc.template` | Template uses `@var@` placeholders for Nix store paths |
| Change zsh source paths | `modules/home/zsh.nix` | Maps `@var@` → Nix store paths via `replaceVars` |
| Change zsh colors | `modules/home/colors.nix` | Catppuccin Mocha palette (hex values) |
| Add a home-manager program | `modules/home/programs.nix` | direnv, htop, etc. |
| Change git config (shared) | `git/.gitconfig` | Shared settings, personal overrides in `~/.gitconfig.local` |
| Change Neovim config | `.config/nvim/` | LazyVim — plugins, keymaps, options, autocmds |
| Change SSH config | `ssh_keys/config` | SSH host definitions |
| Change Starship prompt | `.config/starship.toml` | Prompt theme and modules |
| Change Ghostty config | `.config/ghostty/config` | Terminal colors, fonts, keybinds |
| Change Aerospace config | `.config/aerospace/aerospace.toml` | Tiling rules, layouts, gaps |
| Encrypt a new SSH key | Submit `ssh_keys/*.enc` to git | Use `sops -e -i ssh_keys/id_key` |
| Add an sops recipient | `.sops.yaml` | Add age public key, then `sops updatekeys ssh_keys/*.enc` |
| Change how nix-darwin builds | `flake.nix` | Inputs, specialArgs, module imports |
| Change nixpkgs config | `modules/system/defaults.nix` | Currently: `allowUnfree = true` |

---

## Dendritic Nix module structure

Instead of one giant `darwin.nix` with 500 lines mixing packages, homebrew, macOS defaults, and home-manager config, every concern lives in its own small, focused module. Each module does one thing and is imported by a thin entry point.

### How it works

```
flake.nix                          # "the flake" — pins inputs, exports darwinConfigurations
  └─ darwin.nix                    # "the trunk" — imports system modules + home-manager
       ├─ system/packages.nix      # "branch": CLI tools (environment.systemPackages)
       ├─ system/homebrew.nix      # "branch": GUI apps (casks, brews, taps)
       ├─ system/defaults.nix      # "branch": macOS preferences + nixpkgs config
       └─ home-manager.nix         # "the bridge" — wires home-manager into nix-darwin
            └─ home/default.nix    # "trunk for user": imports home sub-modules
                 ├─ home/files.nix # "branch": dotfile symlinks
                 ├─ home/zsh.nix   # "branch": .zshrc generation (replaceVars + colors)
                 └─ home/programs.nix # "branch": direnv, htop, etc.
```

### Why this matters

- **You know exactly where to look.** Want to add a CLI tool? `packages.nix`. Want a GUI app? `homebrew.nix`. No scrolling through unrelated config.
- **You edit safely.** Changing your `.zshrc` template won't accidentally break Homebrew. Each file has a single responsibility.
- **You can add without fear.** Need to configure a new program? Drop a `programs/ghostty.nix` file and import it. The structure scales linearly — no complexity explosion.
- **You can remove cleanly.** Drop a module and its import line, nothing else breaks.
- **The flake stays portable.** `darwin.nix` is 17 lines. `home/default.nix` is 10 lines. Entry points are thin — all logic is in the named branches.

### Convention

- System-level modules go in `modules/system/`
- User-level (home-manager) modules go in `modules/home/`
- Each file has a header comment: `# ── filename ──` + a one-line description
- Entry points (`darwin.nix`, `home/default.nix`) are import-only — no logic

---

## Everyday commands

### Owner (Tanish)

```bash
macupdate                                          # update flake inputs + rebuild everything
```

Under the hood:
```bash
cd ~/dots/nix-for-mac
nix flake update
sudo darwin-rebuild switch --impure --flake ".#devopss-MacBook-Air"
```

```bash
# Rebuild without updating flake inputs (faster)
sudo darwin-rebuild switch --impure --flake ".#$NIX_HOST"

# Search for a package in nixpkgs
nix search nixpkgs <package>

# See what changed in flake inputs before rebuilding
nix flake diff

# Garbage collect unused store paths (frees disk)
nix-collect-garbage -d
sudo nix-collect-garbage -d

# List all generations (snapshots)
sudo darwin-rebuild --list-generations

# Roll back to previous generation
sudo /run/current-system/sw/bin/darwin-rebuild --rollback

# Homebrew manual operations
brew list --cask
brew upgrade
brew cleanup
```

### After editing config — the rebuild command

```bash
cd ~/dots/nix-for-mac && sudo darwin-rebuild switch --impure --flake ".#$NIX_HOST"
```

Same command every time. Add a package, change a default, swap a color — edit the right file (see table above), run this, done.

### Not-me users

Same commands as above. The only difference: your `$NIX_HOST` is your machine name, and you don't have the age key so SSH key decryption won't happen. Everything else — packages, casks, dotfiles, defaults — is identical.

---

## Secrets (sops + age)

SSH private keys are encrypted in `ssh_keys/*.enc` using [sops][sops] + [age][age]. The plain key files should never exist in git — only `.enc` and `.pub` files.

[sops]: https://github.com/getsops/sops
[age]: https://github.com/FiloSottile/age

**Age key location:** `~/.config/sops/age/keys.txt`

**Recipients** are defined in `.sops.yaml` at the repo root.

**Rotating keys:**

```bash
age-keygen -o ~/.config/sops/age/keys.txt
# Add the new public key to .sops.yaml
sops updatekeys ssh_keys/*.enc
```

---

## File layout

```
nix-for-mac/
├── bootstrap.sh                 # one-command fresh Mac setup
├── flake.nix                    # flake entry point (inputs, outputs, specialArgs)
├── flake.lock                   # pinned versions of nixpkgs, nix-darwin, home-manager
├── lazy-lock.json               # pinned LazyVim plugin versions
├── nix.md                       # this document
└── modules/
    ├── darwin.nix                # system entry point (imports system/ + home-manager bridge)
    ├── home-manager.nix          # bridge: wires home-manager into nix-darwin
    ├── zshrc.template            # .zshrc template (@var@ placeholders → Nix store paths)
    ├── system/
    │   ├── packages.nix          # CLI tools (environment.systemPackages)
    │   ├── homebrew.nix          # GUI apps (casks, brews, taps)
    │   └── defaults.nix          # macOS defaults + nixpkgs config
    └── home/
        ├── default.nix           # home-manager entry point (imports files, zsh, programs)
        ├── files.nix             # dotfile symlinks + sessionPath
        ├── zsh.nix               # generates .zshrc from template + colors
        ├── programs.nix          # home-manager program modules (direnv, htop)
        └── colors.nix            # Catppuccin Mocha palette (imported by zsh.nix)

../ (repo root)
├── .config/                      # dotfiles symlinked into ~/.config/
│   ├── starship.toml
│   ├── ghostty/config
│   ├── aerospace/aerospace.toml
│   └── nvim/                     # LazyVim config
├── git/
│   ├── .gitconfig                # shared git config (includes ~/.gitconfig.local)
│   └── .gitconfig.local.example  # template for personal git identity
├── ssh_keys/
│   ├── config                    # SSH hosts
│   ├── *.pub                     # public keys (tracked)
│   └── *.enc                     # encrypted private keys via sops (tracked)
└── .sops.yaml                    # sops encryption rules (age recipients)
```

---

## FAQ

### Do I need to know Nix to use this?

No. The bootstrap script handles everything. Read "Editing: which file does what" to customize. Run the rebuild command after edits. That's it.

### I never used Nix. Can I still install random things manually?

Yes. `brew install`, `pip install`, `npm install -g` all still work. Nix manages what's declared — it won't delete or conflict with things you add elsewhere.

### Why does everything need sudo now?

nix-darwin manages system-level state (launchd services, /Applications symlinks, /etc files). Home-manager runs under nix-darwin's umbrella. Both require root to activate. This is standard for declarative macOS management.

### Can I still use Ansible for Linux servers?

Yes. `~/dots/ansible/` is untouched. The `macansible` and `linuxansible` aliases in `.zshrc` still work.

### Why `--impure`?

The flake reads `$NIX_USER` and `$NIX_HOST` from the environment. This lets anyone clone the repo and build without editing a single Nix file — just set env vars. Standard pattern for portable nix-darwin flakes.

### What if I installed something with Homebrew manually?

nix-darwin's homebrew module only manages what's listed in `homebrew.nix`. Anything you `brew install` by hand is left alone.

### The bootstrap says "SSH key decryption skipped" — is that bad?

Only if you need my SSH keys. If you're not me, that's expected. Generate your own and encrypt with sops (see Path 2 above).

### How do I uninstall all of this?

```bash
# Remove the nix-darwin generation
sudo rm -rf /run/current-system

# Uninstall Determinate Nix
/nix/nix-installer uninstall

# Delete the repo
rm -rf ~/dots
```
