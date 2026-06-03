# Devcontainer

This directory provides a [VS Code Dev Container](https://code.visualstudio.com/docs/devcontainers/containers)
for developing **on this repository itself**. Consumers using AWS Code Habits
as a submodule do **not** need this container — it exists so contributors can
reproduce the project's CI environment locally.

## What ships in the container

The configuration in [`devcontainer.json`](devcontainer.json) is intentionally
minimal:

| Layer | Source | Purpose |
|---|---|---|
| Base image | `mcr.microsoft.com/devcontainers/base:bullseye` | Debian 11 baseline |
| Feature | `ghcr.io/devcontainers-contrib/features/ansible` | Ansible runtime for `make doc/build` and habits playbooks |
| Feature | `ghcr.io/devcontainers-contrib/features/pre-commit` | `pre-commit` runtime |
| `postCreate` | `apt install bash-completion make` | Tab-completion + GNU Make |

To open the repository inside the container, install the
[Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
extension and run **Dev Containers: Reopen in Container** from the command
palette.

## Verifying the container

Once inside, the standard hygiene loop should pass:

```bash
make doc/build       # regenerates README.md from doc/habits.yaml
make pre-commit/run  # runs all pre-commit hooks
make habits/check    # validates the library
```

## Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common environment issues
(WSL2 SSH-agent, etc.).
