.PHONY: python/install
## Install Python 3
python/install:
	@sudo apt-get update
	@sudo apt-get install --yes python3

.PHONY: python/pip/install
## Install Python 3 Pip
python/pip/install: python/install
	@sudo apt-get install --yes python3-pip
	@pip install --upgrade pip

.PHONY: python/virtualenv/install
## Install Python 3 virtualenv
python/virtualenv/install: python/install python/pip/install
	@sudo apt-get install --yes python3-venv

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
	@echo "--- PYTHON 3 ---"
	@python3 --version
	@echo "--- PIP ---"
	@pip --version
	@pip freeze
