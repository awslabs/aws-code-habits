# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

#####################################################################
# Gitignore Makefile
#
# This Makefile provides targets for working with .gitignore files.
#
# Usage:
#   make gitignore/install       # Install gitignore CLI tool
#   make gitignore/list          # List all available templates
#   make gitignore/init          # Create a .gitignore file
#
# For more information, run: make gitignore/help
#####################################################################

# Default gitignore template rules
GITIGNORE?=macos,windows,linux,visualstudiocode,python,node

# Detect OS for cross-platform compatibility
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
    DETECTED_OS := linux
endif
ifeq ($(UNAME_S),Darwin)
    DETECTED_OS := darwin
endif
ifeq ($(findstring MINGW,$(UNAME_S)),MINGW)
    DETECTED_OS := windows
endif

#####################################################################
# Help
#####################################################################

.PHONY: gitignore/help
## Display help for all gitignore targets
gitignore/help:
	@echo "Gitignore Targets:"
	@echo "  gitignore/install            - Install gitignore CLI tool"
	@echo "  gitignore/list               - List all available templates"
	@echo "  gitignore/init               - Create a .gitignore file with default templates"
	@echo ""
	@echo "Project-Specific Templates:"
	@echo "  gitignore/init/web           - Create .gitignore for web development"
	@echo "  gitignore/init/python        - Create .gitignore for Python development"
	@echo "  gitignore/init/node          - Create .gitignore for Node.js development"
	@echo "  gitignore/init/java          - Create .gitignore for Java development"
	@echo "  gitignore/init/go            - Create .gitignore for Go development"
	@echo "  gitignore/init/terraform     - Create .gitignore for Terraform development"
	@echo "  gitignore/init/aws           - Create .gitignore for AWS development"
	@echo ""
	@echo "File Management:"
	@echo "  gitignore/update             - Update existing .gitignore file"
	@echo "  gitignore/add                - Add new rules to .gitignore"
	@echo "  gitignore/generate           - Generate .gitignore based on project structure"
	@echo ""
	@echo "Variables:"
	@echo "  GITIGNORE                    - Comma-separated list of templates (default: $(GITIGNORE))"

#####################################################################
# Installation
#####################################################################

.PHONY: gitignore/install
## Install gitignore CLI tool
gitignore/install:
ifeq ($(DETECTED_OS),windows)
	@echo "For Windows, please install manually:"
	@echo "1. Download gitignore.sh from $(HABITS)/lib/scripts/gitignore.sh"
	@echo "2. Rename to gitignore.bat"
	@echo "3. Add to your PATH"
else
	@sudo cp $(HABITS)/lib/scripts/gitignore.sh /usr/local/bin/gitignore
	@sudo chmod +x /usr/local/bin/gitignore
endif

#####################################################################
# Template Listing
#####################################################################

.PHONY: gitignore/list
## List all available gitignore templates
gitignore/list:
	@gitignore list

#####################################################################
# Basic Initialization
#####################################################################

.PHONY: gitignore/init
## Create a .gitignore file with default templates
gitignore/init:
	@gitignore $(GITIGNORE) > .gitignore
	@echo "Created .gitignore with templates: $(GITIGNORE)"

#####################################################################
# Project-Specific Templates
#####################################################################

.PHONY: gitignore/init/web
## Create .gitignore for web development
gitignore/init/web: GITIGNORE=macos,windows,linux,visualstudiocode,node,react,angular,vue,sass,less,bower
gitignore/init/web: gitignore/init

.PHONY: gitignore/init/python
## Create .gitignore for Python development
gitignore/init/python: GITIGNORE=macos,windows,linux,visualstudiocode,python,jupyternotebooks,venv,django,flask
gitignore/init/python: gitignore/init

.PHONY: gitignore/init/node
## Create .gitignore for Node.js development
gitignore/init/node: GITIGNORE=macos,windows,linux,visualstudiocode,node,npm,yarn
gitignore/init/node: gitignore/init

.PHONY: gitignore/init/java
## Create .gitignore for Java development
gitignore/init/java: GITIGNORE=macos,windows,linux,visualstudiocode,java,maven,gradle,intellij
gitignore/init/java: gitignore/init

.PHONY: gitignore/init/go
## Create .gitignore for Go development
gitignore/init/go: GITIGNORE=macos,windows,linux,visualstudiocode,go
gitignore/init/go: gitignore/init

.PHONY: gitignore/init/terraform
## Create .gitignore for Terraform development
gitignore/init/terraform: GITIGNORE=macos,windows,linux,visualstudiocode,terraform
gitignore/init/terraform: gitignore/init

.PHONY: gitignore/init/aws
## Create .gitignore for AWS development
gitignore/init/aws: GITIGNORE=macos,windows,linux,visualstudiocode,terraform,node,python,serverless
gitignore/init/aws: gitignore/init

#####################################################################
# File Management
#####################################################################

.PHONY: gitignore/update
## Update existing .gitignore file
gitignore/update:
	@if [ -f .gitignore ]; then \
		echo "Updating .gitignore with templates: $(GITIGNORE)"; \
		gitignore $(GITIGNORE) > .gitignore.new; \
		cat .gitignore | grep -v "# Created by" | grep -v "# Edit at" >> .gitignore.new; \
		sort -u .gitignore.new > .gitignore; \
		rm .gitignore.new; \
	else \
		echo "No .gitignore file found. Creating new one..."; \
		$(MAKE) --no-print-directory gitignore/init; \
	fi

.PHONY: gitignore/add
## Add new rules to .gitignore
gitignore/add:
	$(call assert-set,RULES)
	@if [ -f .gitignore ]; then \
		echo "Adding rules to .gitignore: $(RULES)"; \
		echo "" >> .gitignore; \
		echo "# Custom rules (added $(shell date +%Y-%m-%d))" >> .gitignore; \
		echo "$(RULES)" | tr ',' '\n' >> .gitignore; \
	else \
		echo "No .gitignore file found. Creating new one..."; \
		$(MAKE) --no-print-directory gitignore/init; \
		echo "" >> .gitignore; \
		echo "# Custom rules (added $(shell date +%Y-%m-%d))" >> .gitignore; \
		echo "$(RULES)" | tr ',' '\n' >> .gitignore; \
	fi

.PHONY: gitignore/generate
## Generate .gitignore based on project structure
gitignore/generate:
	@echo "Analyzing project structure..."
	@templates=""
	@if [ -f "package.json" ]; then templates="$$templates,node,npm"; fi
	@if [ -f "yarn.lock" ]; then templates="$$templates,yarn"; fi
	@if [ -f "requirements.txt" ] || [ -d "venv" ] || [ -f "setup.py" ]; then templates="$$templates,python"; fi
	@if [ -f "pom.xml" ] || [ -f "build.gradle" ]; then templates="$$templates,java"; fi
	@if [ -f "go.mod" ]; then templates="$$templates,go"; fi
	@if [ -f "*.tf" ]; then templates="$$templates,terraform"; fi
	@if [ -f ".angular.json" ] || [ -d "angular" ]; then templates="$$templates,angular"; fi
	@if [ -f "react-scripts" ] || [ -d "react" ]; then templates="$$templates,react"; fi
	@templates="$$templates,macos,windows,linux,visualstudiocode"
	@templates=$$(echo $$templates | sed 's/^,//')
	@echo "Detected templates: $$templates"
	@gitignore $$templates > .gitignore
	@echo "Generated .gitignore based on project structure"
