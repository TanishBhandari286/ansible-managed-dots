# dots — common tasks.  Run `just` (or `just --list`) to see them all.
set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

ansible_dir := "ansible"

# List available recipes
default:
    @just --list

# ---- lint & check ---------------------------------------------------------

# Run every linter (yaml, ansible, shell, lua) — mirrors CI
lint:
    yamllint -c .yamllint {{ ansible_dir }}/ .yamllint .pre-commit-config.yaml .github/
    ansible-lint
    shellcheck -S warning install.sh bootstrap-mac.sh bootstrap-public-linux.sh bootstrap_pi.sh
    stylua --check --config-path .config/nvim/stylua.toml .config/nvim

# Syntax-check every playbook (no connection made)
check:
    cd {{ ansible_dir }} && ansible-playbook -i inventory/hosts.ini playbooks/linux.yml --syntax-check
    cd {{ ansible_dir }} && ansible-playbook playbooks/public-linux.yml --syntax-check
    cd {{ ansible_dir }} && ansible-playbook playbooks/mac.yml --syntax-check

# Install / refresh git pre-commit hooks, then run them once
hooks:
    pre-commit install
    pre-commit run --all-files

# ---- provisioning ------------------------------------------------------------

# Provision this macOS workstation
mac:
    cd {{ ansible_dir }} && ansible-playbook playbooks/mac.yml

# Provision a personal Linux host, e.g. `just linux host=vps` (default: all)
linux host="all":
    cd {{ ansible_dir }} && ansible-playbook -i inventory/hosts.ini playbooks/linux.yml --limit {{ host }}

# Dry-run (--check --diff) a personal Linux host, e.g. `just linux-check host=vps`
linux-check host="all":
    cd {{ ansible_dir }} && ansible-playbook -i inventory/hosts.ini playbooks/linux.yml --limit {{ host }} --check --diff

# Ad-hoc connectivity test across the fleet
ping:
    cd {{ ansible_dir }} && ansible linux -m ansible.builtin.ping

# ---- dotfiles symlinks -----------------------------------------------------

# Symlink dotfiles into $HOME (idempotent)
link:
    ./install.sh

# Show what `link` would do without touching anything
link-dry:
    ./install.sh --dry-run

# ---- vault ---------------------------------------------------------------------

# View a vault-encrypted key file, e.g. `just vault-view id_ed25519_ansible`
vault-view file:
    ansible-vault view --vault-password-file {{ ansible_dir }}/.vault_pass ssh_keys/{{ file }}

# Edit a vault-encrypted key file
vault-edit file:
    ansible-vault edit --vault-password-file {{ ansible_dir }}/.vault_pass ssh_keys/{{ file }}

# Re-key every vault file (prompts for the new password) — run after rotating the vault secret
vault-rekey:
    ansible-vault rekey --vault-password-file {{ ansible_dir }}/.vault_pass \
        ssh_keys/id_ed25519_ansible ssh_keys/id_ed25519_sk_key1 ssh_keys/id_ed25519_sk_key2
