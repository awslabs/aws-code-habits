# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

### Features

* Cross-platform OS detection (linux/darwin/windows) in `terraform.mk`, `python.mk`, `go.mk`, `nodejs.mk`, `aws/cdk.mk`.
* Terraform: workspace management, state operations, environment-aware plan/apply/destroy targets.
* AWS CDK: deploy, diff, synth, watch, list, destroy, and per-stack/all variants.
* Python: poetry and pipenv support; consolidated lint/format/test targets.
* Node.js: yarn, pnpm, and npm targets unified; init templates for express/react/vue/next.
* Go: test, coverage, and benchmark targets.
* `gitignore` profiles for web, python, node, java, go, terraform, aws.

### Security

* `permissions:` blocks added to all GitHub Actions workflows (least-privilege `GITHUB_TOKEN`). Backports [#20](https://github.com/awslabs/aws-code-habits/pull/20).
* All GitHub Actions pinned to commit SHAs (with tag comments) and Dependabot configured for weekly bumps.
* Stripped `--no-check-certificate` from `wget` calls in `gomplate`, `terraform-docs`, `tfsec`, and `terrascan` installers.
* `terrascan` install now performs real `sha256sum -c` verification when `TERRASCAN_SHA256` is set; URL updated from `accurics` (legacy) to `tenable`.
* `tflint` install no longer pipes `master`-branch shell scripts through `bash`; replaced with tagged-release zip + optional `TFLINT_SHA256` checksum.
* `aws-nuke` install URL updated from `rebuy-de` (unmaintained) to `ekristen`.
* New `lib/make/make/safety.mk` with a `confirm` macro. Wired into `terraform/apply`, `terraform/destroy`, `aws/cdk/destroy*`, `nuke/run`, and destructive `docker/*` targets. Set `CONFIRM=yes` to bypass for CI.
* `SECURITY.md` now points reporters to <aws-security@amazon.com> and <https://aws.amazon.com/security/vulnerability-reporting/> instead of asking them to file public issues.

### Tool versions

* Terraform 1.5.7 → 1.9.8 (note: BSL transition; override `TERRAFORM_VERSION=1.5.7` for the last MPL release).
* Go 1.21.0 → 1.23.12, Node 18 → 20 (LTS), nvm 0.39.3 → 0.40.4.
* AWS CDK 2.96.2 → 2.257.0, gomplate 3.11.3 → 4.3.3, terraform-docs 0.16.0 → 0.20.0.
* aws-nuke v2.25.0 → v3.65.0, tflint AWS ruleset 0.21.2 → 0.47.0, tfsec 1.15.2 → 1.28.14, terrascan 1.13.2 → 1.19.9.
* `tfsec.mk` now carries a deprecation note pointing users to Aqua's [Trivy](https://github.com/aquasecurity/trivy).

### Documentation

* `refactoring-plan.md` moved out of the repo root to `docs/archive/2025-06-refactoring-plan.md` (it was shipping into every consuming submodule tree).
* New `docs/HARDENING.md` documenting checksum variables, `CONFIRM` gate, and pinning guidance.
* `README.md`: added submodule pinning guidance and a security-posture note.

## [1.5.0](https://github.com/awslabs/aws-code-habits/compare/v1.4.1...v1.5.0) (2024-03-07)


### Features

* Add AWS Amplify makefile and related commands ([6abbcfe](https://github.com/awslabs/aws-code-habits/commit/6abbcfea0eb0819f4b0aec331e76d44262209e27))
* add new targets ([9eac8fd](https://github.com/awslabs/aws-code-habits/commit/9eac8fd800c4e157ee5c457b7883a35f500629df))
* Add npm commands for updating, listing outdated packages, running security audit, and cleaning cache ([cf377fc](https://github.com/awslabs/aws-code-habits/commit/cf377fc7a4817e78dcbc7d4ef61ce88da1378303))
* Add nvm.mk file with nvm installation and version management commands ([66f9271](https://github.com/awslabs/aws-code-habits/commit/66f9271223c8f1d717eb97a9b14a50bbd51e6ad4))
* Add pnpm makefile with commands for package management ([02bd05a](https://github.com/awslabs/aws-code-habits/commit/02bd05a96759b6fe974b3d2d420771f6e034af15))
* Add target to find and display Makefile contents ([a200131](https://github.com/awslabs/aws-code-habits/commit/a200131495cccbca37ec257141adaafa72d33fb7))
* update ([ceff317](https://github.com/awslabs/aws-code-habits/commit/ceff317d9e8282e5662c7754de4c5069b992a4bf))
* Update devcontainer and GitHub Actions workflows ([218315c](https://github.com/awslabs/aws-code-habits/commit/218315c87aecb9348e2514c01cc0a83b1a669b70))
* Update devcontainer configuration ([7d2f8d4](https://github.com/awslabs/aws-code-habits/commit/7d2f8d40c37589067c62ead0806509b056f7f743))
* Update test.yaml workflow ([902d361](https://github.com/awslabs/aws-code-habits/commit/902d361fb7f60a89e59283240a1f90e521f71456))


### Bug Fixes

* indentation ([15fd564](https://github.com/awslabs/aws-code-habits/commit/15fd564cdee17b84748e792469dda2cc76eecfac))
* indentation in npm.mk file ([88da71b](https://github.com/awslabs/aws-code-habits/commit/88da71b9d404394b3c97d3c0a6b8da203c0e421c))
* lack of versions ([d61932a](https://github.com/awslabs/aws-code-habits/commit/d61932a4693e1b57729fd351c72ec17aa3df3f1e))
* Remove unnecessary target from aws/cli/install ([7c48732](https://github.com/awslabs/aws-code-habits/commit/7c48732ae4b4e7c97962e5abcb413b4850f4bb54))

## [1.4.1](https://github.com/awslabs/aws-code-habits/compare/v1.4.0...v1.4.1) (2023-11-10)


### Bug Fixes

* see https://github.com/terraform-linters/tflint/discussions/1680 ([c9fb076](https://github.com/awslabs/aws-code-habits/commit/c9fb0763aa299767fa70aa2e90af6ed664a010a7))

## [1.4.0](https://github.com/awslabs/aws-code-habits/compare/v1.3.0...v1.4.0) (2023-03-07)


### Features

* add cobra command ([3e64a1a](https://github.com/awslabs/aws-code-habits/commit/3e64a1ac6f3c5b01a0a9e9ae65efb4a94014d70e))
* add golang command ([ca9b531](https://github.com/awslabs/aws-code-habits/commit/ca9b5315d04e1e4ca5279cc3c2f17d6a9efcdcaa))

## [1.3.0](https://github.com/awslabs/aws-code-habits/compare/v1.2.0...v1.3.0) (2023-02-15)


### Features

* create rules to initialize pre-commit and .gitignore ([5dc7936](https://github.com/awslabs/aws-code-habits/commit/5dc79366f07aa2d9ac6e9d716883fcadca4280cd))


### Bug Fixes

* remove python target dependencies ([5219f21](https://github.com/awslabs/aws-code-habits/commit/5219f2170517652d6cb8843f98070a4afd29d7df))
* tflient.hcl correct path ([3fa8a05](https://github.com/awslabs/aws-code-habits/commit/3fa8a058bca6a589b92db7471838a1aaf428ef55))

## [1.2.0](https://github.com/awslabs/aws-code-habits/compare/v1.1.0...v1.2.0) (2023-02-03)


### Features

* make references optional ([09c1a79](https://github.com/awslabs/aws-code-habits/commit/09c1a79537dc00df567a4d9bc08aede14ba0bbe4))

## [1.1.0](https://github.com/awslabs/aws-code-habits/compare/v1.0.0...v1.1.0) (2023-01-06)


### Features

* add worfklow release-please ([f1856d8](https://github.com/awslabs/aws-code-habits/commit/f1856d8f185247ff3c0b60a8c20d74ebd7db62b7))
* create make target to install checkov ([457493b](https://github.com/awslabs/aws-code-habits/commit/457493b6c92cda0d51fab88eb5b4bfef49529cbe))


### Bug Fixes

* apply pre-commit rules ([0d5179e](https://github.com/awslabs/aws-code-habits/commit/0d5179ea3ed4ba6b03c29aeb0188915ac7d7df95))
* display terrascan version instead of gomplate ([4e34fa9](https://github.com/awslabs/aws-code-habits/commit/4e34fa9adb5818abcb69587ea63674577b4e7823))
* remove terraform-docs configuration ([953e886](https://github.com/awslabs/aws-code-habits/commit/953e8868f4c30093ff6abe2151fab6c83a63f293))

## [v1.0.0] - 2022-10-27

First release! 🚀
