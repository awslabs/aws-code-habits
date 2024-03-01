.PHONY: pre-commit/install
## Install pre-commit using Pip3
pre-commit/install:
	@pip3 install --progress-bar off --upgrade --user pre-commit

.PHONY: pre-commit/hooks/install
## Install pre-commit hooks
pre-commit/hooks/install: pre-commit/install
	@pre-commit install

.PHONY: pre-commit/update
## Update pre-commit-config.yaml with the latest version
pre-commit/update:
	@pre-commit autoupdate

.PHONY: pre-commit/run
## Execute pre-commit hooks on all files
pre-commit/run:
	@pre-commit run --all-files

.PHONY: pre-commit/init
## Initialize .pre-commit-config.yaml to working directoy
pre-commit/init:
	@cp $(HABITS)/files/pre-commit/.pre-commit-config.yaml ./

.PHONY: pre-commit/remove
## Remove .pre-commit-config.yaml
pre-commit/remove:
	@rm $(WORKSPACE)/.pre-commit-config.yaml

.PHONY: pre-commit/version
## Display pre-commit version
pre-commit/version:
	echo "--- PRE-COMMIT ---"
	@pre-commit --version
