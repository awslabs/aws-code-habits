# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

.PHONY: go/install
## Install Golang
go/install:
	sudo apt-get -qq install --yes golang

.PHONY: go/version
## Display Go version
go/version:
	@echo "--- GO ---"
	@go version

.PHONY: go/env
## Print Go environment information
go/env:
	@go env

.PHONY: go/app/build
## Compile packages and dependencies
go/app/build:
	$(call assert-set,OUTPUT)
	@mkdir -p build
	@go build -o $(OUTPUT)

.PHONY: go/app/install
## Compile and install packages and dependencies
go/app/install:
	@go install

.PHONY: go/app/run
## Compile and run Go program
go/app/run:
	@go run main.go

.PHONY: go/app/fmt
## gofmt (reformat) package sources
go/app/fmt:
	@go fmt ./...
	@gofmt -s -w .

.PHONY: go/app/generate
## Generate Go files by processing source
go/app/generate:
	@go generate ./...

.PHONY: go/app/mod/tidy
## Add missing and remove unused modules
go/app/mod/tidy:
	@go mod tidy

.PHONY: go/app/get
## Add dependencies to current module and install them
go/app/get:
	@go get ./...

.PHONY: go/app/clean
## Remove object files and cached files
go/app/clean:
	@go clean -cache -modcache -i -r

.PHONY: go/app/list
## List packages or modules
go/app/list:
	$(call assert-set,PACKAGE)
	@go list -m -versions $(PACKAGE)
