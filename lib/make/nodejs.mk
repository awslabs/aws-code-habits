.PHONY: nodejs/install/v16
## Install NodeJS v16
nodejs/install/v16:
	@curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
	@sudo bash /tmp/nodesource_setup.sh
	@sudo apt-get update
	@sudo apt-get install --yes nodejs

.PHONY: nodejs/install/v18
## Install NodeJS v18
nodejs/install/v18:
	@curl -sL https://deb.nodesource.com/setup_18.x -o /tmp/nodesource_setup.sh
	@sudo bash /tmp/nodesource_setup.sh
	@sudo apt-get update
	@sudo apt-get install --yes nodejs

.PHONY: nodejs/install/v20
## Install NodeJS v20
nodejs/install/v20:
	@curl -sL https://deb.nodesource.com/setup_20.x -o /tmp/nodesource_setup.sh
	@sudo bash /tmp/nodesource_setup.sh
	@sudo apt-get update
	@sudo apt-get install --yes nodejs

.PHONY: nodejs/install
## Install NodeJS
nodejs/install: nodejs/install/v18

.PHONY: nodejs/version
## Show NodeJS version
nodejs/version:
	@node --version
