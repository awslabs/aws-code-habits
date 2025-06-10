# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

#####################################################################
# AWS CDK Makefile
#
# This Makefile provides targets for working with AWS CDK.
#
# Usage:
#   make aws/cdk/install         # Install AWS CDK
#   make aws/cdk/bootstrap       # Bootstrap CDK environment
#   make aws/cdk/deploy          # Deploy CDK stack
#   make aws/cdk/destroy         # Destroy CDK stack
#
# For more information, run: make aws/cdk/help
#####################################################################

# Default CDK version
CDK_VERSION ?= 2.96.2

# Default CDK directory (can be overridden)
CDK_DIR ?= .

# Default stack name (can be overridden)
STACK_NAME ?= "*"

# Default environment
CDK_ENV ?= dev

#####################################################################
# Help
#####################################################################

.PHONY: aws/cdk/help
## Display help for all AWS CDK targets
aws/cdk/help:
	@echo "AWS CDK Targets:"
	@echo "  aws/cdk/install              - Install AWS CDK"
	@echo "  aws/cdk/install/VERSION      - Install specific AWS CDK version"
	@echo "  aws/cdk/version              - Display AWS CDK version"
	@echo ""
	@echo "Environment Setup:"
	@echo "  aws/cdk/bootstrap            - Bootstrap CDK environment"
	@echo "  aws/cdk/destroy-bootstrap    - Destroy CDK bootstrap resources"
	@echo ""
	@echo "Development Workflow:"
	@echo "  aws/cdk/synth                - Synthesize CloudFormation template"
	@echo "  aws/cdk/diff                 - Compare deployed stack with current state"
	@echo "  aws/cdk/deploy               - Deploy CDK stack"
	@echo "  aws/cdk/deploy/STACK         - Deploy specific stack"
	@echo "  aws/cdk/destroy              - Destroy CDK stack"
	@echo "  aws/cdk/destroy/STACK        - Destroy specific stack"
	@echo "  aws/cdk/watch                - Watch for changes and deploy automatically"
	@echo ""
	@echo "Stack Management:"
	@echo "  aws/cdk/list                 - List all stacks in the app"
	@echo "  aws/cdk/deploy/all           - Deploy all stacks"
	@echo "  aws/cdk/destroy/all          - Destroy all stacks"
	@echo ""
	@echo "Testing:"
	@echo "  aws/cdk/test                 - Run tests"
	@echo "  aws/cdk/test/watch           - Run tests in watch mode"
	@echo ""
	@echo "Variables:"
	@echo "  CDK_DIR                      - CDK project directory (default: .)"
	@echo "  STACK_NAME                   - Stack name (default: *)"
	@echo "  CDK_ENV                      - Environment (default: dev)"
	@echo "  CDK_VERSION                  - CDK version to install (default: $(CDK_VERSION))"

#####################################################################
# Installation & Version
#####################################################################

.PHONY: aws/cdk/install
## Install AWS CDK
aws/cdk/install:
	npm install -g aws-cdk@$(CDK_VERSION)
	@$(MAKE) --no-print-directory aws/cdk/version

.PHONY: aws/cdk/install/VERSION
## Install specific AWS CDK version
aws/cdk/install/VERSION:
	$(eval VERSION := $(word 2,$(subst /, ,$@)))
	@echo "Installing AWS CDK version $(VERSION)..."
	npm install -g aws-cdk@$(VERSION)
	@$(MAKE) --no-print-directory aws/cdk/version

.PHONY: aws/cdk/version
## Display AWS CDK version
aws/cdk/version:
	@echo "--- AWS CDK ---"
	@cdk --version

#####################################################################
# Environment Setup
#####################################################################

.PHONY: aws/cdk/bootstrap
## Bootstrap CDK environment
aws/cdk/bootstrap:
	cd $(CDK_DIR) && npx cdk bootstrap --verbose

.PHONY: aws/cdk/destroy-bootstrap
## Destroy CDK bootstrap resources
aws/cdk/destroy-bootstrap:
	aws cloudformation delete-stack --stack-name CDKToolkit

#####################################################################
# Development Workflow
#####################################################################

.PHONY: aws/cdk/synth
## Synthesize CloudFormation template
aws/cdk/synth:
	cd $(CDK_DIR) && npx cdk synth $(STACK_NAME)

.PHONY: aws/cdk/diff
## Compare deployed stack with current state
aws/cdk/diff:
	cd $(CDK_DIR) && npx cdk diff $(STACK_NAME)

.PHONY: aws/cdk/deploy
## Deploy CDK stack
aws/cdk/deploy:
	cd $(CDK_DIR) && npx cdk deploy $(STACK_NAME) --require-approval never

.PHONY: aws/cdk/deploy/STACK
## Deploy specific stack
aws/cdk/deploy/%:
	$(eval STACK := $(word 2,$(subst /, ,$@)))
	@echo "Deploying stack $(STACK)..."
	cd $(CDK_DIR) && npx cdk deploy $(STACK) --require-approval never

.PHONY: aws/cdk/destroy
## Destroy CDK stack
aws/cdk/destroy:
	cd $(CDK_DIR) && npx cdk destroy $(STACK_NAME) --force

.PHONY: aws/cdk/destroy/STACK
## Destroy specific stack
aws/cdk/destroy/%:
	$(eval STACK := $(word 2,$(subst /, ,$@)))
	@echo "Destroying stack $(STACK)..."
	cd $(CDK_DIR) && npx cdk destroy $(STACK) --force

.PHONY: aws/cdk/watch
## Watch for changes and deploy automatically
aws/cdk/watch:
	cd $(CDK_DIR) && npx cdk watch $(STACK_NAME)

#####################################################################
# Stack Management
#####################################################################

.PHONY: aws/cdk/list
## List all stacks in the app
aws/cdk/list:
	cd $(CDK_DIR) && npx cdk list

.PHONY: aws/cdk/deploy/all
## Deploy all stacks
aws/cdk/deploy/all:
	cd $(CDK_DIR) && npx cdk deploy --all --require-approval never

.PHONY: aws/cdk/destroy/all
## Destroy all stacks
aws/cdk/destroy/all:
	cd $(CDK_DIR) && npx cdk destroy --all --force

#####################################################################
# Testing
#####################################################################

.PHONY: aws/cdk/test
## Run tests
aws/cdk/test:
	cd $(CDK_DIR) && npm test

.PHONY: aws/cdk/test/watch
## Run tests in watch mode
aws/cdk/test/watch:
	cd $(CDK_DIR) && npm test -- --watch

#####################################################################
# Environment-specific commands
#####################################################################

.PHONY: aws/cdk/deploy/env
## Deploy to specific environment
aws/cdk/deploy/env:
	cd $(CDK_DIR) && npx cdk deploy $(STACK_NAME) --require-approval never -c env=$(CDK_ENV)

.PHONY: aws/cdk/synth/env
## Synthesize CloudFormation template for specific environment
aws/cdk/synth/env:
	cd $(CDK_DIR) && npx cdk synth $(STACK_NAME) -c env=$(CDK_ENV)
