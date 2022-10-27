.PHONY: python/install
## Install Python 3
python/install:
	@sudo apt-get -qq install --no-install-recommends --yes python3

.PHONY: python/pip/install
## Install Python 3 Pip
python/pip/install: python/install
	@python3 -m ensurepip --upgrade
	@echo "If you are seeing any warning messages, close your VSCode/Terminal session now, open it again and make sure ${HOME}/.local/bin is in the PATH"

.PHONY: python/virtualenv/install
## Install Python 3 virtualenv
python/virtualenv/install: python/install
	@python3 -m pip install --user virtualenv

.PHONY: python/virtualenv/init
## Initialize a Python 3 virtualenv in the current directory
python/virtualenv/init:
ifeq ("$(wildcard .venv)", "")
	@python3 -m venv .venv
else
	@echo "Skipping virtual environment creation since .venv directory already exists."
endif

.PHONY: python/virtualenv/remove
## Remove Python 3 virtualenv in the current directory
python/virtualenv/remove:
	@rm -rf .venv

.PHONY: python/version
## Display Python & Pip version
python/version:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		echo "--- PYTHON 3 ---" ;\
		python3 --version ;\
		echo "--- PIP ---" ;\
		python3 -m pip --version ;\
		python3 -m pip freeze ;\
	)
