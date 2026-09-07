# Testing

## What runs in CI today (`.github/workflows/ci.yml`, every PR)

| Check | Tool |
|---|---|
| YAML style | `yamllint -c .yamllint` |
| Ansible best-practice / deprecations | `ansible-lint` (`.ansible-lint`, `basic` profile) |
| Playbook parses | `ansible-playbook --syntax-check` for all three playbooks |
| Shell scripts | `shellcheck -S warning` |
| Neovim Lua style | `stylua --check` |

Run the same set locally with `just lint` and `just check`, or install the
git hooks with `just hooks` (`pre-commit`).

## Molecule (scaffolding — NOT in the PR gate yet)

`ansible/.config/molecule/config.yml` plus per-role `molecule/default/`
scenarios exist for the `packages` and `docker` roles. They are **not**
wired into required CI because:

- The Debian roles assume Homebrew-on-Linux; a from-scratch `converge` in
  a container installs Linuxbrew over the network on every run — slow
  (~5–10 min) and network-flaky.
- The `docker` role needs working systemd + `docker-ce` inside the test
  container (docker-in-docker), which needs a privileged, cgroup-mounted
  image and still isn't fully reliable.

### Enable them once the tier-2 refactor lands

After the shared-role refactor decouples the linuxbrew assumption (or we
switch to a pre-baked image that already has brew), do:

```bash
pipx install molecule 'molecule-plugins[docker]' ansible-lint
cd ansible
molecule test -s default          # from within roles/packages or roles/docker
```

Then add a non-blocking `molecule.yml` workflow (`workflow_dispatch` +
weekly `schedule`) and promote it to the PR gate once it's green twice in
a row. The `idempotence` step in `test_sequence` is the real prize — it
fails the moment a task reports `changed` on a second converge, which is
exactly the regression the `changed_when: false` cleanup needs to guard
against.
