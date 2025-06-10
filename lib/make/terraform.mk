# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

#####################################################################
# Terraform Makefile
#
# This Makefile provides targets for working with Terraform.
#
# Usage:
#   make terraform/install         # Install Terraform
#   make terraform/version         # Display Terraform version
#   make terraform/init            # Initialize Terraform
#   make terraform/plan            # Generate execution plan
#   make terraform/apply           # Apply changes
#   make terraform/destroy         # Destroy infrastructure
#
# For more information, run: make terraform/help
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

# Default Terraform version
TERRAFORM_VERSION ?= 1.5.7

#####################################################################
# Help
#####################################################################

.PHONY: terraform/help
## Display help for all terraform targets
terraform/help:
	@echo "Terraform Targets:"
	@echo "  terraform/install              - Install Terraform"
	@echo "  terraform/version              - Display Terraform version"
	@echo ""
	@echo "Project Setup:"
	@echo "  terraform/init                 - Initialize Terraform"
	@echo "  terraform/init/backend         - Initialize with backend config"
	@echo "  terraform/validate             - Validate configuration"
	@echo "  terraform/fmt                  - Format configuration"
	@echo ""
	@echo "Development Workflow:"
	@echo "  terraform/plan                 - Generate execution plan"
	@echo "  terraform/plan/ENV             - Generate plan for environment (dev, staging, prod)"
	@echo "  terraform/apply                - Apply changes"
	@echo "  terraform/apply/ENV            - Apply changes for environment"
	@echo "  terraform/destroy              - Destroy infrastructure"
	@echo "  terraform/destroy/ENV          - Destroy infrastructure for environment"
	@echo ""
	@echo "Workspace Management:"
	@echo "  terraform/workspace/list       - List workspaces"
	@echo "  terraform/workspace/new        - Create new workspace"
	@echo "  terraform/workspace/select     - Select workspace"
	@echo "  terraform/workspace/delete     - Delete workspace"
	@echo ""
	@echo "State Management:"
	@echo "  terraform/state/list           - List resources in state"
	@echo "  terraform/state/mv             - Move items in state"
	@echo "  terraform/state/pull           - Pull current state"
	@echo "  terraform/state/push           - Push state"
	@echo "  terraform/state/rm             - Remove items from state"
	@echo ""
	@echo "Terraform Cloud:"
	@echo "  terraform/cloud/login          - Login to Terraform Cloud"
	@echo "  terraform/cloud/logout         - Logout from Terraform Cloud"
	@echo ""
	@echo "Module Management:"
	@echo "  terraform/module/get           - Get modules"
	@echo "  terraform/module/update        - Update modules"
	@echo ""
	@echo "Cleanup:"
	@echo "  terraform/clean                - Remove temporary files and directories"
	@echo ""
	@echo "Project Setup:"
	@echo "  terraform/pre-commit/init      - Initialize pre-commit config"
	@echo "  terraform/gitignore/init       - Initialize gitignore for Terraform"

#####################################################################
# Installation & Version
#####################################################################

.PHONY: terraform/install
## Install Terraform
terraform/install:
ifeq ($(DETECTED_OS),linux)
ifeq ($(IS_APT),true)
	wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null
	echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(shell lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
	sudo apt-get update && sudo apt-get -qq install --no-install-recommends --yes terraform terraform-ls
else
	@echo "Installing Terraform $(TERRAFORM_VERSION) for Linux..."
	wget -q https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_linux_amd64.zip
	unzip -o terraform_$(TERRAFORM_VERSION)_linux_amd64.zip
	sudo mv terraform /usr/local/bin/
	rm terraform_$(TERRAFORM_VERSION)_linux_amd64.zip
endif
else ifeq ($(DETECTED_OS),darwin)
	@echo "Installing Terraform for macOS..."
	brew install terraform
else ifeq ($(DETECTED_OS),windows)
	@echo "Installing Terraform for Windows..."
	@echo "Please install Terraform manually from https://www.terraform.io/downloads.html"
	@echo "Or use Chocolatey: choco install terraform"
else
	@echo "Unsupported OS. Please install Terraform manually from https://www.terraform.io/downloads.html"
endif
	@$(MAKE) --no-print-directory terraform/version

.PHONY: terraform/install/VERSION
## Install specific Terraform version
terraform/install/VERSION:
	$(eval VERSION := $(word 2,$(subst /, ,$@)))
	@echo "Installing Terraform $(VERSION)..."
ifeq ($(DETECTED_OS),linux)
	wget -q https://releases.hashicorp.com/terraform/$(VERSION)/terraform_$(VERSION)_linux_amd64.zip
	unzip -o terraform_$(VERSION)_linux_amd64.zip
	sudo mv terraform /usr/local/bin/
	rm terraform_$(VERSION)_linux_amd64.zip
else ifeq ($(DETECTED_OS),darwin)
	wget -q https://releases.hashicorp.com/terraform/$(VERSION)/terraform_$(VERSION)_darwin_amd64.zip
	unzip -o terraform_$(VERSION)_darwin_amd64.zip
	sudo mv terraform /usr/local/bin/
	rm terraform_$(VERSION)_darwin_amd64.zip
else
	@echo "Please install Terraform $(VERSION) manually from https://www.terraform.io/downloads.html"
endif
	@$(MAKE) --no-print-directory terraform/version

.PHONY: terraform/version
## Display Terraform version
terraform/version:
	@echo "--- TERRAFORM ---"
	@terraform --version

#####################################################################
# Project Setup
#####################################################################

.PHONY: terraform/init
## Initialize a new or existing Terraform working directory
terraform/init: tfswitch/run terraform/fmt tflint/run
	terraform init

.PHONY: terraform/init/backend
## Initialize with backend config
terraform/init/backend: tfswitch/run terraform/fmt
	terraform init -backend-config="backend.hcl"

.PHONY: terraform/fmt
## Format Terraform configuration files
terraform/fmt:
	terraform fmt
	terraform fmt -check=true

.PHONY: terraform/validate
## Validate the configuration files
terraform/validate:
	terraform validate

#####################################################################
# Development Workflow
#####################################################################

.PHONY: terraform/plan
## Generate an execution plan
terraform/plan: tfswitch/run terraform/fmt terraform/validate
	terraform plan

.PHONY: terraform/plan/dev terraform/plan/staging terraform/plan/prod
## Generate an execution plan for specific environment
terraform/plan/%: tfswitch/run terraform/fmt terraform/validate
	$(eval ENV := $(word 2,$(subst /, ,$@)))
	@echo "Planning for $(ENV) environment..."
	terraform plan -var-file="environments/$(ENV).tfvars"

.PHONY: terraform/apply
## Build or change infrastructure
terraform/apply: tfswitch/run terraform/fmt terraform/validate
	terraform apply -auto-approve

.PHONY: terraform/apply/dev terraform/apply/staging terraform/apply/prod
## Build or change infrastructure for specific environment
terraform/apply/%: tfswitch/run terraform/fmt terraform/validate
	$(eval ENV := $(word 2,$(subst /, ,$@)))
	@echo "Applying changes for $(ENV) environment..."
	terraform apply -auto-approve -var-file="environments/$(ENV).tfvars"

.PHONY: terraform/destroy
## Destroy Terraform-managed infrastructure
terraform/destroy: tfswitch/run terraform/fmt terraform/validate
	terraform destroy -auto-approve

.PHONY: terraform/destroy/dev terraform/destroy/staging terraform/destroy/prod
## Destroy Terraform-managed infrastructure for specific environment
terraform/destroy/%: tfswitch/run terraform/fmt terraform/validate
	$(eval ENV := $(word 2,$(subst /, ,$@)))
	@echo "Destroying infrastructure for $(ENV) environment..."
	terraform destroy -auto-approve -var-file="environments/$(ENV).tfvars"

#####################################################################
# Workspace Management
#####################################################################

.PHONY: terraform/workspace/list
## List workspaces
terraform/workspace/list:
	terraform workspace list

.PHONY: terraform/workspace/new
## Create a new workspace
terraform/workspace/new:
	$(call assert-set,WORKSPACE_NAME)
	terraform workspace new $(WORKSPACE_NAME)

.PHONY: terraform/workspace/select
## Select a workspace
terraform/workspace/select:
	$(call assert-set,WORKSPACE_NAME)
	terraform workspace select $(WORKSPACE_NAME)

.PHONY: terraform/workspace/delete
## Delete a workspace
terraform/workspace/delete:
	$(call assert-set,WORKSPACE_NAME)
	terraform workspace delete $(WORKSPACE_NAME)

#####################################################################
# State Management
#####################################################################

.PHONY: terraform/state/list
## List resources in the state
terraform/state/list:
	terraform state list

.PHONY: terraform/state/mv
## Move an item in the state
terraform/state/mv:
	$(call assert-set,SOURCE)
	$(call assert-set,DESTINATION)
	terraform state mv $(SOURCE) $(DESTINATION)

.PHONY: terraform/state/pull
## Pull current state
terraform/state/pull:
	terraform state pull

.PHONY: terraform/state/push
## Push state
terraform/state/push:
	$(call assert-set,STATE_PATH)
	terraform state push $(STATE_PATH)

.PHONY: terraform/state/rm
## Remove items from the state
terraform/state/rm:
	$(call assert-set,ADDRESS)
	terraform state rm $(ADDRESS)

#####################################################################
# Terraform Cloud
#####################################################################

.PHONY: terraform/cloud/login
## Login to Terraform Cloud
terraform/cloud/login:
	terraform login

.PHONY: terraform/cloud/logout
## Logout from Terraform Cloud
terraform/cloud/logout:
	terraform logout

#####################################################################
# Module Management
#####################################################################

.PHONY: terraform/module/get
## Get modules
terraform/module/get:
	terraform get

.PHONY: terraform/module/update
## Update modules
terraform/module/update:
	terraform get -update

#####################################################################
# Cleanup
#####################################################################

.PHONY: terraform/clean
## Remove temporary files and directories
terraform/clean:
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f *.tfstate*
	rm -f *.tar.gz
	rm -f *.log

#####################################################################
# Project Setup
#####################################################################

.PHONY: terraform/pre-commit/init
## Initialize pre-commit config for Terraform
terraform/pre-commit/init:
	@cp $(HABITS)/files/terraform/.pre-commit-config.yaml ./

.PHONY: terraform/gitignore/init
## Initialize gitignore for Terraform
terraform/gitignore/init: GITIGNORE=macos,windows,linux,visualstudiocode,terraform
terraform/gitignore/init: gitignore/install gitignore/init
