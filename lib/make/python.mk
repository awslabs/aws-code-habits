# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

#####################################################################
# Python Makefile
#
# This Makefile provides targets for working with Python.
#
# Usage:
#   make python/install         # Install Python 3
#   make python/version         # Display Python version
#   make python/virtualenv/init # Initialize a virtual environment
#   make python/test            # Run tests
#
# For more information, run: make python/help
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

# Default Python version
PYTHON_VERSION ?= 3.11

# Default project directory
PYTHON_DIR ?= .

# Default test directory
TEST_DIR ?= tests

#####################################################################
# Help
#####################################################################

.PHONY: python/help
## Display help for all Python targets
python/help:
	@echo "Python Targets:"
	@echo "  python/install              - Install Python 3"
	@echo "  python/install/VERSION      - Install specific Python version"
	@echo "  python/version              - Display Python & Pip version"
	@echo ""
	@echo "Environment Setup:"
	@echo "  python/virtualenv/install   - Install virtualenv"
	@echo "  python/virtualenv/init      - Initialize a virtual environment"
	@echo "  python/virtualenv/remove    - Remove virtual environment"
	@echo "  python/poetry/install       - Install Poetry"
	@echo "  python/poetry/init          - Initialize a Poetry project"
	@echo "  python/pipenv/install       - Install Pipenv"
	@echo "  python/pipenv/init          - Initialize a Pipenv project"
	@echo ""
	@echo "Dependency Management:"
	@echo "  python/requirements/generate - Generate requirements.txt"
	@echo "  python/requirements/install  - Install from requirements.txt"
	@echo "  python/requirements/update   - Update dependencies"
	@echo "  python/pip/install          - Install Python 3 Pip"
	@echo ""
	@echo "Development Workflow:"
	@echo "  python/run                  - Run Python script"
	@echo "  python/test                 - Run tests"
	@echo "  python/test/coverage        - Run tests with coverage"
	@echo "  python/lint                 - Run linter"
	@echo "  python/format               - Format code"
	@echo ""
	@echo "Variables:"
	@echo "  PYTHON_VERSION              - Python version (default: $(PYTHON_VERSION))"
	@echo "  PYTHON_DIR                  - Python project directory (default: .)"
	@echo "  TEST_DIR                    - Test directory (default: tests)"

#####################################################################
# Installation & Version
#####################################################################

.PHONY: python/install
## Install Python 3
python/install:
ifeq ($(DETECTED_OS),linux)
ifeq ($(IS_APT),true)
	@sudo apt-get update
	@sudo apt-get install --yes python3 python3-dev
else
	@echo "Please install Python manually for your Linux distribution"
endif
else ifeq ($(DETECTED_OS),darwin)
	@echo "Installing Python for macOS..."
	brew install python
else ifeq ($(DETECTED_OS),windows)
	@echo "Installing Python for Windows..."
	@echo "Please install Python manually from https://www.python.org/downloads/"
	@echo "Or use Chocolatey: choco install python"
else
	@echo "Unsupported OS. Please install Python manually from https://www.python.org/downloads/"
endif
	@$(MAKE) --no-print-directory python/version

.PHONY: python/install/VERSION
## Install specific Python version
python/install/VERSION:
	$(eval VERSION := $(word 2,$(subst /, ,$@)))
	@echo "Installing Python $(VERSION)..."
ifeq ($(DETECTED_OS),linux)
ifeq ($(IS_APT),true)
	@sudo add-apt-repository ppa:deadsnakes/ppa -y
	@sudo apt-get update
	@sudo apt-get install --yes python$(VERSION) python$(VERSION)-dev python$(VERSION)-venv
else
	@echo "Please install Python $(VERSION) manually for your Linux distribution"
endif
else ifeq ($(DETECTED_OS),darwin)
	brew install python@$(VERSION)
else
	@echo "Please install Python $(VERSION) manually from https://www.python.org/downloads/"
endif
	@$(MAKE) --no-print-directory python/version

.PHONY: python/pip/install
## Install Python 3 Pip
python/pip/install: python/install
ifeq ($(DETECTED_OS),linux)
ifeq ($(IS_APT),true)
	@sudo apt-get install --yes python3-pip
else
	@curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	@python3 get-pip.py
	@rm get-pip.py
endif
else ifeq ($(DETECTED_OS),darwin)
	@echo "Pip is included with Python on macOS"
else
	@echo "Please ensure pip is installed with your Python installation"
endif
	@pip install --upgrade pip

.PHONY: python/version
## Display Python & Pip version
python/version:
	@echo "--- PYTHON 3 ---"
	@python3 --version
	@echo "--- PIP ---"
	@pip --version
	@pip freeze

#####################################################################
# Environment Setup
#####################################################################

.PHONY: python/virtualenv/install
## Install Python 3 virtualenv
python/virtualenv/install: python/install python/pip/install
ifeq ($(DETECTED_OS),linux)
ifeq ($(IS_APT),true)
	@sudo apt-get install --yes python3-venv
else
	@pip install virtualenv
endif
else
	@pip install virtualenv
endif

.PHONY: python/virtualenv/init
## Initialize a Python 3 virtualenv in the current directory
python/virtualenv/init:
ifeq ("$(wildcard .venv)", "")
	@python3 -m venv .venv
	@echo "Virtual environment created. Activate with: source .venv/bin/activate"
else
	@echo "Skipping virtual environment creation since .venv directory already exists."
endif

.PHONY: python/virtualenv/remove
## Remove Python 3 virtualenv in the current directory
python/virtualenv/remove:
	@rm -rf .venv

.PHONY: python/poetry/install
## Install Poetry
python/poetry/install: python/pip/install
	@pip install poetry
	@poetry --version

.PHONY: python/poetry/init
## Initialize a Poetry project
python/poetry/init:
	@cd $(PYTHON_DIR) && poetry init -n

.PHONY: python/poetry/add
## Add a dependency with Poetry
python/poetry/add:
	$(call assert-set,PACKAGE)
	@cd $(PYTHON_DIR) && poetry add $(PACKAGE)

.PHONY: python/poetry/add/dev
## Add a development dependency with Poetry
python/poetry/add/dev:
	$(call assert-set,PACKAGE)
	@cd $(PYTHON_DIR) && poetry add --group dev $(PACKAGE)

.PHONY: python/pipenv/install
## Install Pipenv
python/pipenv/install: python/pip/install
	@pip install pipenv
	@pipenv --version

.PHONY: python/pipenv/init
## Initialize a Pipenv project
python/pipenv/init:
	@cd $(PYTHON_DIR) && pipenv --python $(PYTHON_VERSION)

#####################################################################
# Dependency Management
#####################################################################

.PHONY: python/requirements/generate
## Generate requirements.txt
python/requirements/generate:
ifeq ($(wildcard $(PYTHON_DIR)/poetry.lock),)
	@echo "No poetry.lock found, using pip freeze"
	@pip freeze > $(PYTHON_DIR)/requirements.txt
else
	@cd $(PYTHON_DIR) && poetry export -f requirements.txt --output requirements.txt
endif

.PHONY: python/requirements/install
## Install from requirements.txt
python/requirements/install:
ifeq ($(wildcard $(PYTHON_DIR)/requirements.txt),)
	@echo "No requirements.txt found"
else
	@pip install -r $(PYTHON_DIR)/requirements.txt
endif

.PHONY: python/requirements/update
## Update dependencies
python/requirements/update:
ifeq ($(wildcard $(PYTHON_DIR)/poetry.lock),)
	@pip list --outdated
	@echo "Run 'pip install --upgrade PACKAGE' to update a package"
else
	@cd $(PYTHON_DIR) && poetry update
endif

#####################################################################
# Development Workflow
#####################################################################

.PHONY: python/run
## Run Python script
python/run:
	$(call assert-set,SCRIPT)
	@cd $(PYTHON_DIR) && python3 $(SCRIPT)

.PHONY: python/test
## Run tests
python/test:
ifeq ($(wildcard $(PYTHON_DIR)/pyproject.toml),)
	@cd $(PYTHON_DIR) && python -m pytest $(TEST_DIR)
else
	@cd $(PYTHON_DIR) && python -m pytest
endif

.PHONY: python/test/coverage
## Run tests with coverage
python/test/coverage:
	@cd $(PYTHON_DIR) && python -m pytest --cov=$(PYTHON_DIR) $(TEST_DIR)

.PHONY: python/lint
## Run linter
python/lint:
	@cd $(PYTHON_DIR) && python -m flake8 .

.PHONY: python/format
## Format code
python/format:
	@cd $(PYTHON_DIR) && python -m black .

#####################################################################
# Project Setup
#####################################################################

.PHONY: python/setup/dev
## Set up development environment
python/setup/dev: python/virtualenv/init
	@pip install pytest pytest-cov flake8 black
	@echo "Development environment set up successfully"

.PHONY: python/setup/poetry
## Set up Poetry development environment
python/setup/poetry: python/poetry/install python/poetry/init
	@cd $(PYTHON_DIR) && poetry add --group dev pytest pytest-cov flake8 black
	@echo "Poetry development environment set up successfully"

.PHONY: python/setup/pipenv
## Set up Pipenv development environment
python/setup/pipenv: python/pipenv/install python/pipenv/init
	@cd $(PYTHON_DIR) && pipenv install pytest pytest-cov flake8 black --dev
	@echo "Pipenv development environment set up successfully"
