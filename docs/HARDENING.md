# Hardening Guide

This document lists the security knobs that AWS Code Habits exposes and the
defaults that ship with the library. Every variable here is overridable in
your project's `tools.env` (or on the command line), so you can pick the
posture that fits your environment.

## Confirmation gate for destructive targets

Several Make targets are destructive: they auto-approve Terraform changes,
delete CDK stacks with `--force`, run `aws-nuke --no-dry-run --force`, or
prune Docker resources without prompting. To prevent accidental invocation,
all of them now route through a shared `confirm` macro defined in
[`lib/make/make/safety.mk`](../lib/make/make/safety.mk).

When you run a gated target, you'll see:

```text
WARNING: terraform/destroy will PERMANENTLY DESTROY all infrastructure
Type 'yes' to continue, anything else to abort:
```

Targets currently gated:

| Target | Risk |
|---|---|
| `terraform/apply`, `terraform/apply/<env>` | Modifies infra without preview |
| `terraform/destroy`, `terraform/destroy/<env>` | Deletes all (or per-env) infra |
| `aws/cdk/destroy`, `aws/cdk/destroy/<stack>` | Deletes a CDK stack |
| `aws/cdk/destroy/all` | Deletes every CDK stack in the app |
| `aws/cdk/destroy-bootstrap` | Deletes the `CDKToolkit` bootstrap stack |
| `nuke/run` | Permanently deletes AWS resources matching the config |
| `docker/remove-images`, `docker/remove-volumes`, `docker/prune` | Removes local Docker state |

To bypass the prompt in CI, set `CONFIRM=yes`:

```bash
make terraform/destroy CONFIRM=yes
```

The macro reads from `/dev/tty`, so it works inside chained shell pipelines
and recipe lines.

## Checksum verification for tool installers

Several tools are downloaded from upstream GitHub releases. Each installer
supports an optional `*_SHA256` variable. When set, the recipe runs
`sha256sum -c` against the downloaded archive and aborts on mismatch. When
unset, the recipe prints a `WARNING` line and proceeds (so existing
environments keep working).

| Tool | Version variable | Checksum variable |
|---|---|---|
| tflint | `TFLINT_VERSION` | `TFLINT_SHA256` |
| terrascan | `TERRASCAN_VERSION` | `TERRASCAN_SHA256` |

Where to find the canonical SHA256:

- **tflint** — `https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/checksums.txt`
- **terrascan** — `https://github.com/tenable/terrascan/releases/download/v${TERRASCAN_VERSION}/terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz.sha256sum`

Add the resolved hash to your `tools.env`:

```env
TFLINT_VERSION=0.63.0
TFLINT_SHA256=<paste from upstream checksums.txt>

TERRASCAN_VERSION=1.19.9
TERRASCAN_SHA256=<paste from upstream .sha256sum>
```

This pattern is being extended to the other installers (`gomplate`,
`terraform-docs`, `tfsec`, `aws-nuke`) over time.

## Pinning your habits submodule

`README.md` recommends adding habits with `-b main`. After cloning, **pin
the submodule to a tagged release or commit SHA** rather than tracking a
moving branch:

```bash
git -C habits fetch --tags
git -C habits checkout v1.5.0
git add habits && git commit -m "chore: pin habits to v1.5.0"
```

This guarantees reproducible builds and prevents upstream changes from
landing in your project until you explicitly bump the pointer. See
[CHANGELOG.md](../CHANGELOG.md) for the list of releases and what each
includes.

## GitHub Actions hygiene

Workflows in this repo are pinned to commit SHAs (with the original tag
preserved as a comment) and Dependabot is configured to bump them weekly:

```yaml
- uses: actions/checkout@f43a0e5ff2bd294095638e18286ca9a3d1956744 # v3
```

If you copy any workflow snippets from this repository into your own, keep
the SHA pin — it removes a real attack path where a malicious upstream
release tag can be quietly retagged onto a new commit.

The `permissions:` blocks on every workflow scope `GITHUB_TOKEN` to the
minimum the job actually needs (`contents: read` for tests,
`contents: write` + `pull-requests: write` for `release-please`).

## Tool license notes

- **Terraform** — `TERRAFORM_VERSION` defaults to `1.9.8` (BSL). The last
  Mozilla Public License (MPL) release was `1.5.7`. If your organization
  requires an MPL toolchain, override `TERRAFORM_VERSION=1.5.7` in
  `tools.env` or migrate to [OpenTofu](https://opentofu.org/).
- **tfsec** — Aqua has deprecated tfsec in favor of
  [Trivy](https://github.com/aquasecurity/trivy). The `tfsec.mk` targets
  still work, but you should plan a migration.
- **terrascan** — The project moved upstream from `accurics` to `tenable`.
  The installer URL has been updated; older `tools.env` files that override
  `TERRASCAN_VERSION` continue to work.
- **aws-nuke** — Upstream moved from `rebuy-de/aws-nuke` (unmaintained) to
  [`ekristen/aws-nuke`](https://github.com/ekristen/aws-nuke). The default
  `AWS_NUKE_VERSION` is now a v3.x release.

## Reporting a security issue

See [SECURITY.md](../SECURITY.md). Do **not** file public GitHub issues
for security vulnerabilities.
