# Hardening guide

This guide lists the security controls that AWS Code Habits exposes and the defaults that ship with the library. You override every variable here in your project's `tools.env` or on the command line, so you choose the posture that fits your environment.

## Confirmation gate for destructive targets

Several Make targets are destructive: they auto-approve Terraform changes, delete AWS Cloud Development Kit (AWS CDK) stacks with `--force`, run `aws-nuke --no-dry-run --force`, or prune Docker resources without prompting. To prevent accidental invocation, all of them route through a shared `confirm` macro defined in [`lib/make/make/safety.mk`](../lib/make/make/safety.mk).

When you run a gated target, you see a prompt:

```text
WARNING: terraform/destroy will PERMANENTLY DESTROY all infrastructure
Type 'yes' to continue, anything else to abort:
```

The following targets are gated:

| Target                                                          | Risk                                                  |
| --------------------------------------------------------------- | ----------------------------------------------------- |
| `terraform/apply`, `terraform/apply/<env>`                      | Modifies infrastructure without preview               |
| `terraform/destroy`, `terraform/destroy/<env>`                  | Deletes all (or per-environment) infrastructure       |
| `aws/cdk/destroy`, `aws/cdk/destroy/<stack>`                    | Deletes an AWS CDK stack                              |
| `aws/cdk/destroy/all`                                           | Deletes every AWS CDK stack in the app                |
| `aws/cdk/destroy-bootstrap`                                     | Deletes the `CDKToolkit` bootstrap stack              |
| `nuke/run`                                                      | Permanently deletes AWS resources matching the config |
| `docker/remove-images`, `docker/remove-volumes`, `docker/prune` | Removes local Docker state                            |

To bypass the prompt in continuous integration, set `CONFIRM=yes`:

```bash
make terraform/destroy CONFIRM=yes
```

The macro reads from `/dev/tty`, so it works inside chained shell pipelines and recipe lines.

## Checksum verification for tool installers

Several tools are downloaded from upstream GitHub releases. Each installer supports an optional `*_SHA256` variable. When you set it, the recipe runs `sha256sum -c` against the downloaded archive and aborts on mismatch. When you leave it unset, the recipe prints a `WARNING` line and proceeds, so existing environments keep working.

| Tool      | Version variable    | Checksum variable  |
| --------- | ------------------- | ------------------ |
| tflint    | `TFLINT_VERSION`    | `TFLINT_SHA256`    |
| terrascan | `TERRASCAN_VERSION` | `TERRASCAN_SHA256` |

Find the canonical SHA256 at these locations:

- **tflint** — `https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/checksums.txt`
- **terrascan** — `https://github.com/tenable/terrascan/releases/download/v${TERRASCAN_VERSION}/terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz.sha256sum`

Add the resolved hash to your `tools.env`:

```env
TFLINT_VERSION=0.63.0
TFLINT_SHA256=<paste from upstream checksums.txt>

TERRASCAN_VERSION=1.19.9
TERRASCAN_SHA256=<paste from upstream .sha256sum>
```

This pattern is being extended to the other installers (`gomplate`, `terraform-docs`, `tfsec`, `aws-nuke`) over time.

## Pinning your habits submodule

The `README.md` install steps add habits with `-b main`. After you clone, pin the submodule to a tagged release or commit SHA rather than tracking a moving branch:

```bash
git -C habits fetch --tags
git -C habits checkout v1.5.0
git add habits && git commit -m "chore: pin habits to v1.5.0"
```

Pinning guarantees reproducible builds and prevents upstream changes from landing in your project until you explicitly bump the pointer. See [CHANGELOG.md](../CHANGELOG.md) for the list of releases and what each includes.

## GitHub Actions hygiene

Workflows in this repository are pinned to commit SHAs, with the original tag preserved as a comment, and Dependabot bumps them weekly:

```yaml
- uses: actions/checkout@f43a0e5ff2bd294095638e18286ca9a3d1956744 # v3
```

If you copy any workflow snippets from this repository into your own, keep the SHA pin. It removes a real attack path where an attacker retags a release tag onto a malicious commit.

The `permissions:` block on every workflow scopes `GITHUB_TOKEN` to the minimum the job needs: `contents: read` for tests, and `contents: write` plus `pull-requests: write` for `release-please`.

## Tool license notes

- **Terraform** — `TERRAFORM_VERSION` defaults to `1.9.8` (Business Source License). The last Mozilla Public License (MPL) release was `1.5.7`. If your organization requires an MPL toolchain, override `TERRAFORM_VERSION=1.5.7` in `tools.env`, or migrate to [OpenTofu](https://opentofu.org/).
- **tfsec** — Aqua has deprecated tfsec in favor of [Trivy](https://github.com/aquasecurity/trivy). The `tfsec.mk` targets still work, but plan a migration.
- **terrascan** — The project moved upstream from `accurics` to `tenable`. The installer URL is updated; older `tools.env` files that override `TERRASCAN_VERSION` continue to work.
- **aws-nuke** — Upstream moved from `rebuy-de/aws-nuke` (unmaintained) to [`ekristen/aws-nuke`](https://github.com/ekristen/aws-nuke). The default `AWS_NUKE_VERSION` is now a v3.x release.

## Reporting a security issue

See [SECURITY.md](../SECURITY.md). Do not file public GitHub issues for security vulnerabilities.
