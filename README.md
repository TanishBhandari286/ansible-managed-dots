# dots

Personal dotfiles + infrastructure-as-code. One repo, one tool — **Ansible** — provisions both macOS and Linux.

- **Repo owner?** Read **[PERSONAL.md](PERSONAL.md)** — what you get with your vault-decrypted keys.
- **Trying this yourself?** Read **[PUBLIC.md](PUBLIC.md)** — what you get with the public one-liner, no secrets involved.
- **Want the big picture?** [`architecture.df`](architecture.df) — paste it into [Eraser](https://app.eraser.io) for a diagram.

## Layout

```
.zshrc, .config/, git/     # dotfiles, symlinked onto the target by install.sh
ansible/playbooks/         # mac.yml, linux.yml, public-linux.yml
ansible/roles/             # packages, shell, node, docker, ssh, dotfiles
ssh_keys/                  # SSH keys, Ansible Vault-encrypted at rest
```
