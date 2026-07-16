# Nix macOS Dotfiles

Fully declarative macOS setup using [nix-darwin][nd] + [home-manager][hm].
One `curl | bash` and your Mac is ready.

[nd]: https://github.com/LnL7/nix-darwin
[hm]: https://github.com/nix-community/home-manager

---

## What this gives you

| Layer | Tool | What |
|-------|------|------|
| **System** | nix-darwin | CLI packages, macOS defaults, Homebrew integration |
| **User** | home-manager | Dotfiles (.zshrc, .gitconfig, nvim, ghostty, aerospace, etc.) |
| **Secrets** | sops + age | SSH keys encrypted in the repo, decrypted on your machine only |
| **GUI apps** | Homebrew casks | Ghostty, VS Code, OrbStack, Raycast, Brave, Obsidian, etc. |

## For someone else (fresh Mac — 1 command)

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/nix-for-mac/bootstrap.sh)"
```

What happens:
1. Installs Xcode CLI tools (waits for GUI if needed)
2. Installs Homebrew
3. Installs Determinate Nix
4. Clones this repo to `~/dots`
5. Creates `~/.gitconfig.local` from the example template — **edit this with your name/email**
6. Builds and activates nix-darwin + home-manager (all packages, casks, dotfiles)
7. Skips SSH key decryption (needs your age key — see [secrets](#secrets) below)
8. `exec zsh` and you're done

### Custom username / hostname

```bash
NIX_USER=alice NIX_HOST=alices-macbook bash bootstrap.sh
```

### After bootstrap — make it yours

1. **Git identity** — edit `~/.gitconfig.local`:
   ```
   [user]
       name = Your Name
       email = you@example.com
   ```

2. **SSH config** — add your hosts to `~/.ssh/config.dots-local`:
   ```
   Host myserver
       HostName 192.168.x.x
       User myuser
       IdentityFile ~/.ssh/id_ed25519
   ```

3. **SSH keys** — generate and add to sops:
   ```bash
   age-keygen -o ~/.config/sops/age/keys.txt
   # Add the public key to .sops.yaml, then:
   sops -e -i --age <YOUR_PUBKEY> ssh_keys/id_ed25519
   ```

### Customize what's installed

Edit `nix-for-mac/modules/darwin.nix`:
- `environment.systemPackages` — CLI tools (add/remove packages)
- `homebrew.casks` — GUI apps
- `system.defaults` — macOS settings (dock, finder, keyboard, etc.)

Then rebuild.

---

## For the owner (Tanish)

### Day-to-day

```bash
macupdate          # update flake inputs + rebuild everything
```

That's it. It runs:
```bash
cd ~/dots/nix-for-mac
nix flake update
sudo darwin-rebuild switch --impure --flake ".#devopss-MacBook-Air"
```

### Rebuild without updating inputs

```bash
cd ~/dots/nix-for-mac && sudo darwin-rebuild switch --impure --flake ".#devopss-MacBook-Air"
```

### Add a package

Edit `nix-for-mac/modules/darwin.nix` and add it to `environment.systemPackages`, then:
```bash
cd ~/dots/nix-for-mac && sudo darwin-rebuild switch --impure --flake ".#devopss-MacBook-Air"
```

Or search first:
```bash
nix search nixpkgs <package-name>
```

### Add a Homebrew cask (GUI app not in nixpkgs)

Edit `nix-for-mac/modules/darwin.nix` → add to `homebrew.casks`, then rebuild.

### Edit config files

Configs live in `~/dots/` and are symlinked by home-manager. Edit the real file in the repo:

| Config | Repo path |
|--------|-----------|
| zshrc | `.zshrc` → `nix-for-mac/modules/zshrc.template` |
| Git | `git/.gitconfig` |
| Starship | `.config/starship.toml` |
| Ghostty | `.config/ghostty/config` |
| Aerospace | `.config/aerospace/aerospace.toml` |
| Neovim | `.config/nvim/` (LazyVim) |
| SSH | `ssh_keys/config` |

After editing, rebuild.

### Encrypt new SSH keys

```bash
sops -e -i ssh_keys/id_new_key
git add ssh_keys/id_new_key.enc
```

### Decrypt SSH keys on a new machine

```bash
# (age key must be at ~/.config/sops/age/keys.txt)
sops -d ssh_keys/id_ed25519_ansible.enc > ~/.ssh/id_ed25519_ansible
chmod 600 ~/.ssh/id_ed25519_ansible
```

### See what changed before rebuilding

```bash
cd ~/dots/nix-for-mac && nix flake diff
```

### Garbage collect unused Nix store paths

```bash
nix-collect-garbage -d
sudo nix-collect-garbage -d
```

### Roll back to previous generation

```bash
darwin-rebuild --list-generations
sudo /run/current-system/sw/bin/darwin-rebuild --rollback
```

### Manual Homebrew operations

```bash
brew list --cask      # list GUI apps
brew upgrade          # upgrade everything
brew cleanup          # remove old versions
```

---

## File layout

```
nix-for-mac/
├── bootstrap.sh            # one-command fresh Mac setup
├── flake.nix               # flake entry point (inputs, outputs)
├── flake.lock              # pinned versions of nixpkgs, nix-darwin, home-manager
├── lazy-lock.json          # pinned LazyVim plugin versions
├── nix.md                  # this file
└── modules/
    ├── darwin.nix           # system: packages, homebrew, macOS defaults
    ├── home.nix             # user: dotfiles (zshrc, git, nvim, ghostty, etc.)
    └── zshrc.template       # .zshrc template (Nix substitutes store paths)
```

---

## Secrets (sops-nix)

SSH private keys are encrypted in `ssh_keys/*.enc` using [sops][sops] + [age][age].

[sops]: https://github.com/getsops/sops
[age]: https://github.com/FiloSottile/age

**Age key location:** `~/.config/sops/age/keys.txt`

**Encryption rules** are in `.sops.yaml` at the repo root. Both the SSH public key (converted to age) and a standalone age key are registered as recipients.

**Rotating keys:**

```bash
age-keygen -o ~/.config/sops/age/keys.txt
# Add the new public key to .sops.yaml
sops updatekeys ssh_keys/*.enc
```

---

## How it works (architecture)

```
bootstrap.sh
  ├─ Xcode CLI tools
  ├─ Homebrew (/opt/homebrew)
  ├─ Determinate Nix
  ├─ git clone ~/dots
  └─ darwin-rebuild switch --impure --flake .#<hostname>
       ├─ nix-darwin (darwin.nix)
       │   ├─ environment.systemPackages    → /run/current-system/sw/bin
       │   ├─ homebrew.casks/brews/taps     → /opt/homebrew
       │   ├─ system.defaults               → macOS preferences
       │   └─ sops (CLI)                    → decrypt SSH keys
       └─ home-manager (home.nix)
           ├─ home.file / xdg.configFile    → symlinks in ~/ and ~/.config/
           ├─ programs.direnv               → nix-direnv integration
           └─ home.sessionPath              → /opt/homebrew/bin added to PATH
```

**Key design choice:** CLI tools come from nixpkgs. GUI apps come from Homebrew (because many aren't packaged in nixpkgs on macOS). `brew` is installed and on PATH, so you can use it manually too.

---

## FAQ

### Do I need to know Nix to use this?

No. Run `macupdate` to update. Edit config by editing the real files in `~/dots/` and rebuilding.

### What if I installed something with `brew install` manually?

It'll keep working. The nix-darwin `homebrew` module only manages what's listed in `darwin.nix` — it won't touch anything else.

### Can I still use Ansible for Linux servers?

Yes. The Ansible playbooks in `~/dots/ansible/` are untouched. `macansible` and `linuxansible` aliases still work.

### Why `--impure`?

The flake reads `$NIX_USER` and `$NIX_HOST` environment variables to support any machine without hardcoding hostnames. This is the standard pattern for portable nix-darwin configs.

### The bootstrap script doesn't detect my machine properly

Set env vars before running:
```bash
NIX_USER=myuser NIX_HOST=my-mac bash bootstrap.sh
```
