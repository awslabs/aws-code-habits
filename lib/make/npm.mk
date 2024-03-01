.PHONY: npm/install
## Install NPM
npm/install:
	@sudo apt-get update
	@sudo apt-get install --yes npm

.PHONY: npm/aws-sso-creds-helper/install
## Install NPM package sso-creds (DevContainer)
npm/aws-sso-creds-helper/install:
	@source /usr/local/share/nvm/nvm.sh && npm install -g aws-sso-creds-helper
