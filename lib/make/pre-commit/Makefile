.PHONY: pre-commit/install
## Install pre-commit using Pip3
pre-commit/install: python/pip/install
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		pip install --upgrade pre-commit ;\
	)

.PHONY: pre-commit/hooks/install
## Install pre-commit hooks
pre-commit/hooks/install: python/pip/install pre-commit/install
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		pre-commit install ;\
	)

.PHONY: pre-commit/update
## Update pre-commit-config.yaml with the latest version
pre-commit/update:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		pre-commit autoupdate ;\
	)

# TODO: make habits/check mandatory?

.PHONY: pre-commit/run
## Execute pre-commit hooks on all files
pre-commit/run:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		pre-commit run --all-files ;\
	)

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
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		echo "--- PRE-COMMIT ---" ;\
		pre-commit --version ;\
	)
