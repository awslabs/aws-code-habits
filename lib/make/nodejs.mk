# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

#####################################################################
# Node.js Makefile
#
# This Makefile provides targets for working with Node.js, npm, yarn, and pnpm.
#
# Usage:
#   make nodejs/install         # Install Node.js
#   make nodejs/version         # Display Node.js version
#   make npm/install            # Install a package with npm
#   make yarn/install           # Install a package with yarn
#   make pnpm/install           # Install a package with pnpm
#
# For more information, run: make nodejs/help
#####################################################################

# Detect OS for cross-platform compatibility
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    DETECTED_OS := linux
    ifeq ($(shell which apt-get 2>/dev/null),)
        IS_APT := false
    else
        IS_APT := true
    endif
endif
ifeq ($(UNAME_S),Darwin)
    DETECTED_OS := darwin
endif
ifeq ($(findstring MINGW,$(UNAME_S)),MINGW)
    DETECTED_OS := windows
endif

# Default Node.js version
NODE_VERSION ?= 18

# Default project directory
NODE_DIR ?= .

# Default package manager
PACKAGE_MANAGER ?= npm

#####################################################################
# Help
#####################################################################

.PHONY: nodejs/help
## Display help for all Node.js targets
nodejs/help:
	@echo "Node.js Targets:"
	@echo "  nodejs/install              - Install Node.js (default v$(NODE_VERSION))"
	@echo "  nodejs/install/vXX          - Install specific Node.js version (v16, v18, v20)"
	@echo "  nodejs/version              - Display Node.js version"
	@echo ""
	@echo "NPM Targets:"
	@echo "  npm/install                 - Install npm"
	@echo "  npm/version                 - Display npm version"
	@echo "  npm/install-global          - Set npm global for current user"
	@echo "  npm/update-path             - Update PATH for npm global"
	@echo "  npm/update                  - Update packages to latest version"
	@echo "  npm/outdated                - List outdated packages"
	@echo "  npm/audit                   - Run security audit"
	@echo "  npm/clean-cache             - Clean npm cache"
	@echo ""
	@echo "Yarn Targets:"
	@echo "  yarn/install                - Install Yarn"
	@echo "  yarn/version                - Display Yarn version"
	@echo "  yarn/update                 - Update packages to latest version"
	@echo "  yarn/outdated               - List outdated packages"
	@echo "  yarn/audit                  - Run security audit"
	@echo "  yarn/clean-cache            - Clean Yarn cache"
	@echo ""
	@echo "PNPM Targets:"
	@echo "  pnpm/install                - Install pnpm"
	@echo "  pnpm/version                - Display pnpm version"
	@echo "  pnpm/update                 - Update packages to latest version"
	@echo "  pnpm/outdated               - List outdated packages"
	@echo "  pnpm/audit                  - Run security audit"
	@echo "  pnpm/clean-cache            - Clean pnpm cache"
	@echo ""
	@echo "Project Initialization:"
	@echo "  nodejs/init/express         - Initialize Express.js project"
	@echo "  nodejs/init/react           - Initialize React project"
	@echo "  nodejs/init/vue             - Initialize Vue.js project"
	@echo "  nodejs/init/next            - Initialize Next.js project"
	@echo ""
	@echo "Development Workflow:"
	@echo "  nodejs/run                  - Run Node.js script"
	@echo "  nodejs/test                 - Run tests"
	@echo "  nodejs/lint                 - Run linter"
	@echo "  nodejs/format               - Format code"
	@echo ""
	@echo "Variables:"
	@echo "  NODE_VERSION                - Node.js version (default: $(NODE_VERSION))"
	@echo "  NODE_DIR                    - Node.js project directory (default: .)"
	@echo "  PACKAGE_MANAGER             - Package manager to use (npm, yarn, pnpm) (default: npm)"

#####################################################################
# Node.js Installation & Version
#####################################################################

.PHONY: nodejs/install
## Install Node.js (default version)
nodejs/install: nodejs/install/v$(NODE_VERSION)

.PHONY: nodejs/install/v16 nodejs/install/v18 nodejs/install/v20
## Install specific Node.js version
nodejs/install/v%:
	$(eval VERSION := $(word 2,$(subst /, ,$@)))
	$(eval VERSION_NUM := $(subst v,,$(VERSION)))
	@echo "Installing Node.js $(VERSION)..."
ifeq ($(DETECTED_OS),linux)
ifeq ($(IS_APT),true)
	@curl -sL https://deb.nodesource.com/setup_$(VERSION_NUM).x -o /tmp/nodesource_setup.sh
	@sudo bash /tmp/nodesource_setup.sh
	@sudo apt-get update
	@sudo apt-get install --yes nodejs
else
	@echo "Installing Node.js $(VERSION) for Linux..."
	@curl -fsSL https://nodejs.org/dist/latest-$(VERSION)/node-$(shell curl -s https://nodejs.org/dist/latest-$(VERSION)/ | grep -o 'node-v[0-9.]*-linux-x64.tar.gz' | head -1) -o /tmp/node.tar.gz
	@sudo tar -xzf /tmp/node.tar.gz -C /usr/local --strip-components=1
	@rm /tmp/node.tar.gz
endif
else ifeq ($(DETECTED_OS),darwin)
	@echo "Installing Node.js $(VERSION) for macOS..."
	brew install node@$(VERSION_NUM)
	brew link --overwrite node@$(VERSION_NUM)
else ifeq ($(DETECTED_OS),windows)
	@echo "Installing Node.js $(VERSION) for Windows..."
	@echo "Please install Node.js manually from https://nodejs.org/en/download/"
	@echo "Or use Chocolatey: choco install nodejs-lts"
else
	@echo "Unsupported OS. Please install Node.js manually from https://nodejs.org/en/download/"
endif
	@$(MAKE) --no-print-directory nodejs/version

.PHONY: nodejs/version
## Display Node.js version
nodejs/version:
	@echo "--- NODE.JS ---"
	@node --version

#####################################################################
# NPM
#####################################################################

.PHONY: npm/install
## Install npm
npm/install:
ifeq ($(DETECTED_OS),linux)
ifeq ($(IS_APT),true)
	@sudo apt-get update
	@sudo apt-get install --yes npm
else
	@echo "npm is included with Node.js"
endif
else
	@echo "npm is included with Node.js"
endif
	@$(MAKE) --no-print-directory npm/version

.PHONY: npm/version
## Display npm version
npm/version:
	@echo "--- NPM ---"
	@npm --version

.PHONY: npm/install-global
## Set npm global for current user
npm/install-global:
	mkdir -p ~/.npm-global
	npm config set prefix '~/.npm-global'

.PHONY: npm/update-path
## Update PATH for npm global
npm/update-path:
	echo 'export PATH=~/.npm-global/bin:$$PATH' >> ~/.bashrc
	source ~/.bashrc

.PHONY: npm/update
## Update packages to the latest version
npm/update:
	cd $(NODE_DIR) && npm update

.PHONY: npm/outdated
## List outdated packages
npm/outdated:
	cd $(NODE_DIR) && npm outdated

.PHONY: npm/audit
## Run security audit
npm/audit:
	cd $(NODE_DIR) && npm audit

.PHONY: npm/clean-cache
## Clean npm cache
npm/clean-cache:
	npm cache clean --force

#####################################################################
# Yarn
#####################################################################

.PHONY: yarn/install
## Install Yarn
yarn/install:
	npm install -g yarn
	@$(MAKE) --no-print-directory yarn/version

.PHONY: yarn/version
## Display Yarn version
yarn/version:
	@echo "--- YARN ---"
	@yarn --version

.PHONY: yarn/update
## Update packages to the latest version with Yarn
yarn/update:
	cd $(NODE_DIR) && yarn upgrade

.PHONY: yarn/outdated
## List outdated packages with Yarn
yarn/outdated:
	cd $(NODE_DIR) && yarn outdated

.PHONY: yarn/audit
## Run security audit with Yarn
yarn/audit:
	cd $(NODE_DIR) && yarn audit

.PHONY: yarn/clean-cache
## Clean Yarn cache
yarn/clean-cache:
	yarn cache clean

#####################################################################
# PNPM
#####################################################################

.PHONY: pnpm/install
## Install pnpm
pnpm/install:
	npm install -g pnpm
	@$(MAKE) --no-print-directory pnpm/version

.PHONY: pnpm/version
## Display pnpm version
pnpm/version:
	@echo "--- PNPM ---"
	@pnpm --version

.PHONY: pnpm/update
## Update packages to the latest version with pnpm
pnpm/update:
	cd $(NODE_DIR) && pnpm update

.PHONY: pnpm/outdated
## List outdated packages with pnpm
pnpm/outdated:
	cd $(NODE_DIR) && pnpm outdated

.PHONY: pnpm/audit
## Run security audit with pnpm
pnpm/audit:
	cd $(NODE_DIR) && pnpm audit

.PHONY: pnpm/clean-cache
## Clean pnpm cache
pnpm/clean-cache:
	pnpm store prune

#####################################################################
# Project Initialization
#####################################################################

.PHONY: nodejs/init/express
## Initialize Express.js project
nodejs/init/express:
	@echo "Initializing Express.js project..."
	mkdir -p $(NODE_DIR)
	cd $(NODE_DIR) && npx express-generator
	cd $(NODE_DIR) && $(PACKAGE_MANAGER) install
	@echo "Express.js project initialized successfully"

.PHONY: nodejs/init/react
## Initialize React project
nodejs/init/react:
	@echo "Initializing React project..."
	cd $(NODE_DIR) && npx create-react-app .
	@echo "React project initialized successfully"

.PHONY: nodejs/init/vue
## Initialize Vue.js project
nodejs/init/vue:
	@echo "Initializing Vue.js project..."
	cd $(NODE_DIR) && npx @vue/cli create . --default
	@echo "Vue.js project initialized successfully"

.PHONY: nodejs/init/next
## Initialize Next.js project
nodejs/init/next:
	@echo "Initializing Next.js project..."
	cd $(NODE_DIR) && npx create-next-app .
	@echo "Next.js project initialized successfully"

#####################################################################
# Development Workflow
#####################################################################

.PHONY: nodejs/run
## Run Node.js script
nodejs/run:
	$(call assert-set,SCRIPT)
	cd $(NODE_DIR) && node $(SCRIPT)

.PHONY: nodejs/test
## Run tests
nodejs/test:
	cd $(NODE_DIR) && $(PACKAGE_MANAGER) test

.PHONY: nodejs/lint
## Run linter
nodejs/lint:
ifeq ($(PACKAGE_MANAGER),npm)
	cd $(NODE_DIR) && npm run lint
else ifeq ($(PACKAGE_MANAGER),yarn)
	cd $(NODE_DIR) && yarn lint
else ifeq ($(PACKAGE_MANAGER),pnpm)
	cd $(NODE_DIR) && pnpm lint
endif

.PHONY: nodejs/format
## Format code
nodejs/format:
ifeq ($(PACKAGE_MANAGER),npm)
	cd $(NODE_DIR) && npm run format
else ifeq ($(PACKAGE_MANAGER),yarn)
	cd $(NODE_DIR) && yarn format
else ifeq ($(PACKAGE_MANAGER),pnpm)
	cd $(NODE_DIR) && pnpm format
endif

#####################################################################
# Package Installation Helpers
#####################################################################

.PHONY: nodejs/add
## Add a package using the selected package manager
nodejs/add:
	$(call assert-set,PACKAGE)
ifeq ($(PACKAGE_MANAGER),npm)
	cd $(NODE_DIR) && npm install $(PACKAGE)
else ifeq ($(PACKAGE_MANAGER),yarn)
	cd $(NODE_DIR) && yarn add $(PACKAGE)
else ifeq ($(PACKAGE_MANAGER),pnpm)
	cd $(NODE_DIR) && pnpm add $(PACKAGE)
endif

.PHONY: nodejs/add/dev
## Add a development package using the selected package manager
nodejs/add/dev:
	$(call assert-set,PACKAGE)
ifeq ($(PACKAGE_MANAGER),npm)
	cd $(NODE_DIR) && npm install --save-dev $(PACKAGE)
else ifeq ($(PACKAGE_MANAGER),yarn)
	cd $(NODE_DIR) && yarn add --dev $(PACKAGE)
else ifeq ($(PACKAGE_MANAGER),pnpm)
	cd $(NODE_DIR) && pnpm add -D $(PACKAGE)
endif

.PHONY: nodejs/remove
## Remove a package using the selected package manager
nodejs/remove:
	$(call assert-set,PACKAGE)
ifeq ($(PACKAGE_MANAGER),npm)
	cd $(NODE_DIR) && npm uninstall $(PACKAGE)
else ifeq ($(PACKAGE_MANAGER),yarn)
	cd $(NODE_DIR) && yarn remove $(PACKAGE)
else ifeq ($(PACKAGE_MANAGER),pnpm)
	cd $(NODE_DIR) && pnpm remove $(PACKAGE)
endif
