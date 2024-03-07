NVM_VERSION ?= v0.39.3

.PHONY: nvm/install
## Install nvm
nvm/install:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$(NVM_VERSION)/install.sh | bash

.PHONY: nvm/use
## Use a specific Node.js version
nvm/use:
	nvm use $(version)

.PHONY: nvm/list-versions
## List installed Node.js versions
nvm/list-versions:
	nvm ls
