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
npm/install-global:
	mkdir -p ~/.npm-global
	npm config set prefix '~/.npm-global'

.PHONY: npm/update-path
npm/update-path:
    echo 'export PATH=~/.npm-global/bin:$$PATH' >> ~/.bashrc
    source ~/.bashrc
