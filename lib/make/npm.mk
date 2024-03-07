.PHONY: npm/install
## Install NPM
npm/install:
	@sudo apt-get update
	@sudo apt-get install --yes npm

.PHONY: npm/version
## Show NPM version
npm/version:
	@npm --version

.PHONY: npm/install-global
# Set npm global for current user
npm/install-global:
	mkdir -p ~/.npm-global
	npm config set prefix '~/.npm-global'

.PHONY: npm/update-path
npm/update-path:
	echo 'export PATH=~/.npm-global/bin:$$PATH' >> ~/.bashrc
	source ~/.bashrc

.PHONY: npm/update
## Update packages to the latest version
npm/update:
	npm update

.PHONY: npm/outdated
## List outdated packages
npm/outdated:
	npm outdated

.PHONY: npm/audit
## Run security audit
npm/audit:
	npm audit

.PHONY: npm/clean-cache
## Clean npm cache
npm/clean-cache:
	npm cache clean --force
