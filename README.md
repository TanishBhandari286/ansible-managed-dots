# dots

Personal dotfiles + infrastructure-as-code. One repo, one tool — **Ansible** — provisions both macOS and Linux.

- **Repo owner?** Read **[PERSONAL.md](PERSONAL.md)** — what you get with your vault-decrypted keys.
- **Trying this yourself?** Read **[PUBLIC.md](PUBLIC.md)** — what you get with the public one-liner, no secrets involved.

## Layout

```
bootstrap-mac.sh           # curl one-liner entry point — macOS
bootstrap-public-linux.sh  # curl one-liner entry point — Linux
install.sh                 # symlinks dotfiles; called by the playbooks, not run directly
justfile                   # common tasks: `just lint`, `just check`, `just mac`, `just linux host=vps`
.zshrc, .config/, git/     # dotfiles, symlinked onto the target
ansible/playbooks/         # mac.yml, linux.yml, public-linux.yml
ansible/roles/             # packages, shell, node, docker, ssh, dotfiles
ssh_keys/                  # SSH keys, Ansible Vault-encrypted at rest
```

## Architecture

```mermaid
flowchart TD
    owner([Repo owner]):::person
    stranger([Stranger]):::person

    owner --> bm[bootstrap-mac.sh]
    stranger --> bm
    owner -->|"just linux"| lx[linux.yml]
    stranger --> bpl[bootstrap-public-linux.sh]

    bm --> mac[mac.yml]
    bpl --> pl[public-linux.yml]

    subgraph roles [Shared roles]
        direction LR
        packages --> shell --> node --> docker --> ssh --> dotfiles
    end

    lx --> roles
    pl -.->|"ssh role skipped"| roles
    mac -.->|"flat tasks, no roles"| mtasks["brew bundle · mise · macOS defaults · install.sh"]

    vault[("Ansible Vault\nssh_keys/id_* encrypted\n.vault_pass gitignored, owner-only")]:::secret
    mac -->|"owner only: real-decrypt check"| vault
    ssh -->|"deploy automation + FIDO2 keys"| vault

    roles --> hosts["vps · master-node · dp-2 · dp"]
    mtasks --> workstation["macOS workstation"]
    pl --> localhost["localhost (public mode)"]

    classDef person fill:#7aa2f7,stroke:#1d202f,color:#1d202f;
    classDef secret fill:#f7768e,stroke:#1d202f,color:#1d202f;
```
