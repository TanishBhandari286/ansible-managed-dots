# Personal Setup

For the repo owner — you hold `ansible/.vault_pass` and the vault-encrypted keys in `ssh_keys/`. Running the same entry points below unlocks the owner-only steps that a stranger's run skips.

## What you get beyond the public setup

- Your real SSH keys — `id_ed25519_ansible` (automation) and your FIDO2 keys — decrypted into `~/.ssh`
- Your git identity from `~/.gitconfig.local`
- On Linux: the actual inventoried hosts (`vps`, `master-node`, `cp`, `dp`) get provisioned, not just the machine you're sitting at
- The `ssh` role: GitHub's host key pinned, automation key deployed to every server so future `dotfiles` pulls need no password

## macOS

SSH keys decrypt automatically because you have the vault password:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/TanishBhandari286/ansible-managed-dots/main/install.sh)"
```

Update anytime with the `macupdate` shell alias.

## Linux (servers / VPS)

Edit `ansible/inventory/hosts.ini` with your host(s), then:

```bash
cd ~/dots/ansible
ansible-playbook -i inventory/hosts.ini playbooks/linux.yml
```

Or just run the `linuxansible` shell alias if the repo's already cloned. This is the only path that deploys real secrets — only point it at boxes you own.
