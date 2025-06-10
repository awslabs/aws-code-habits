.PHONY: pnpm/install
## Install a package with pnpm
pnpm/install:
	sudo npm install -g pnpm

.PHONY: pnpm/update
## Update packages to the latest version with pnpm
pnpm/update:
	pnpm update

.PHONY: pnpm/outdated
## List outdated packages with pnpm
pnpm/outdated:
	pnpm outdated

.PHONY: pnpm/audit
## Run security audit with pnpm
pnpm/audit:
	pnpm audit

.PHONY: pnpm/clean-cache
## Clean pnpm cache
pnpm/clean-cache:
	pnpm store prune
