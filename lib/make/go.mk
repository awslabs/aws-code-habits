# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

#####################################################################
# Go Makefile
#
# This Makefile provides targets for working with Go.
#
# Usage:
#   make go/install         # Install Go
#   make go/version         # Display Go version
#   make go/app/build       # Build Go application
#   make go/app/test        # Run tests
#
# For more information, run: make go/help
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

# Default Go version
GO_VERSION ?= 1.21.0

# Default output directory
OUTPUT_DIR ?= build

# Default main file
MAIN_FILE ?= main.go

# Default package for testing
TEST_PACKAGE ?= ./...

#####################################################################
# Help
#####################################################################

.PHONY: go/help
## Display help for all Go targets
go/help:
	@echo "Go Targets:"
	@echo "  go/install                 - Install Go"
	@echo "  go/install/VERSION         - Install specific Go version"
	@echo "  go/version                 - Display Go version"
	@echo "  go/env                     - Print Go environment information"
	@echo ""
	@echo "Application Development:"
	@echo "  go/app/build               - Compile packages and dependencies"
	@echo "  go/app/install             - Compile and install packages and dependencies"
	@echo "  go/app/run                 - Compile and run Go program"
	@echo "  go/app/fmt                 - Format Go code"
	@echo "  go/app/generate            - Generate Go files by processing source"
	@echo "  go/app/clean               - Remove object files and cached files"
	@echo ""
	@echo "Module Management:"
	@echo "  go/app/mod/init            - Initialize a new module"
	@echo "  go/app/mod/tidy            - Add missing and remove unused modules"
	@echo "  go/app/mod/vendor          - Make vendored copy of dependencies"
	@echo "  go/app/mod/download        - Download modules to local cache"
	@echo "  go/app/get                 - Add dependencies to current module and install them"
	@echo "  go/app/list                - List packages or modules"
	@echo ""
	@echo "Testing:"
	@echo "  go/app/test                - Run tests"
	@echo "  go/app/test/coverage       - Run tests with coverage"
	@echo "  go/app/test/benchmark      - Run benchmarks"
	@echo "  go/app/lint                - Run linter"
	@echo ""
	@echo "Variables:"
	@echo "  GO_VERSION                 - Go version (default: $(GO_VERSION))"
	@echo "  OUTPUT_DIR                 - Output directory (default: $(OUTPUT_DIR))"
	@echo "  MAIN_FILE                  - Main file (default: $(MAIN_FILE))"
	@echo "  TEST_PACKAGE               - Package for testing (default: $(TEST_PACKAGE))"
	@echo "  OUTPUT                     - Output binary name (required for go/app/build)"
	@echo "  PACKAGE                    - Package name (required for go/app/list)"

#####################################################################
# Installation & Version
#####################################################################

.PHONY: go/install
## Install Go
go/install:
ifeq ($(DETECTED_OS),linux)
ifeq ($(IS_APT),true)
	sudo apt-get -qq install --yes golang
else
	@echo "Installing Go $(GO_VERSION) for Linux..."
	wget -q https://golang.org/dl/go$(GO_VERSION).linux-amd64.tar.gz
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf go$(GO_VERSION).linux-amd64.tar.gz
	rm go$(GO_VERSION).linux-amd64.tar.gz
	@echo "Add the following to your .bashrc or .zshrc:"
	@echo "export PATH=\$$PATH:/usr/local/go/bin"
endif
else ifeq ($(DETECTED_OS),darwin)
	@echo "Installing Go for macOS..."
	brew install go
else ifeq ($(DETECTED_OS),windows)
	@echo "Installing Go for Windows..."
	@echo "Please install Go manually from https://golang.org/dl/"
	@echo "Or use Chocolatey: choco install golang"
else
	@echo "Unsupported OS. Please install Go manually from https://golang.org/dl/"
endif
	@$(MAKE) --no-print-directory go/version

.PHONY: go/install/VERSION
## Install specific Go version
go/install/VERSION:
	$(eval VERSION := $(word 2,$(subst /, ,$@)))
	@echo "Installing Go $(VERSION)..."
ifeq ($(DETECTED_OS),linux)
	wget -q https://golang.org/dl/go$(VERSION).linux-amd64.tar.gz
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf go$(VERSION).linux-amd64.tar.gz
	rm go$(VERSION).linux-amd64.tar.gz
	@echo "Add the following to your .bashrc or .zshrc:"
	@echo "export PATH=\$$PATH:/usr/local/go/bin"
else ifeq ($(DETECTED_OS),darwin)
	brew install go@$(VERSION)
	brew link --overwrite go@$(VERSION)
else
	@echo "Please install Go $(VERSION) manually from https://golang.org/dl/"
endif
	@$(MAKE) --no-print-directory go/version

.PHONY: go/version
## Display Go version
go/version:
	@echo "--- GO ---"
	@go version

.PHONY: go/env
## Print Go environment information
go/env:
	@go env

#####################################################################
# Application Development
#####################################################################

.PHONY: go/app/build
## Compile packages and dependencies
go/app/build:
	$(call assert-set,OUTPUT)
	@mkdir -p $(OUTPUT_DIR)
	@go build -o $(OUTPUT_DIR)/$(OUTPUT) $(MAIN_FILE)
	@echo "Built $(OUTPUT) in $(OUTPUT_DIR)"

.PHONY: go/app/install
## Compile and install packages and dependencies
go/app/install:
	@go install

.PHONY: go/app/run
## Compile and run Go program
go/app/run:
	@go run $(MAIN_FILE)

.PHONY: go/app/fmt
## Format Go code
go/app/fmt:
	@go fmt ./...
	@gofmt -s -w .

.PHONY: go/app/generate
## Generate Go files by processing source
go/app/generate:
	@go generate ./...

.PHONY: go/app/clean
## Remove object files and cached files
go/app/clean:
	@go clean -cache -modcache -i -r
	@rm -rf $(OUTPUT_DIR)

#####################################################################
# Module Management
#####################################################################

.PHONY: go/app/mod/init
## Initialize a new module
go/app/mod/init:
	$(call assert-set,MODULE_NAME)
	@go mod init $(MODULE_NAME)

.PHONY: go/app/mod/tidy
## Add missing and remove unused modules
go/app/mod/tidy:
	@go mod tidy

.PHONY: go/app/mod/vendor
## Make vendored copy of dependencies
go/app/mod/vendor:
	@go mod vendor

.PHONY: go/app/mod/download
## Download modules to local cache
go/app/mod/download:
	@go mod download

.PHONY: go/app/get
## Add dependencies to current module and install them
go/app/get:
	@go get ./...

.PHONY: go/app/list
## List packages or modules
go/app/list:
	$(call assert-set,PACKAGE)
	@go list -m -versions $(PACKAGE)

#####################################################################
# Testing
#####################################################################

.PHONY: go/app/test
## Run tests
go/app/test:
	@go test $(TEST_PACKAGE)

.PHONY: go/app/test/coverage
## Run tests with coverage
go/app/test/coverage:
	@mkdir -p $(OUTPUT_DIR)
	@go test -coverprofile=$(OUTPUT_DIR)/coverage.out $(TEST_PACKAGE)
	@go tool cover -html=$(OUTPUT_DIR)/coverage.out -o $(OUTPUT_DIR)/coverage.html
	@echo "Coverage report generated at $(OUTPUT_DIR)/coverage.html"

.PHONY: go/app/test/benchmark
## Run benchmarks
go/app/test/benchmark:
	@go test -bench=. $(TEST_PACKAGE)

.PHONY: go/app/lint
## Run linter
go/app/lint:
	@if command -v golangci-lint > /dev/null; then \
		golangci-lint run; \
	else \
		echo "golangci-lint not found. Installing..."; \
		go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest; \
		golangci-lint run; \
	fi
