.DEFAULT_GOAL := help

SHELL = /bin/bash

export SELF ?= $(MAKE)
export EDITOR ?= vim

green = $(shell echo -e '\x1b[32;01m$1\x1b[0m')
yellow = $(shell echo -e '\x1b[33;01m$1\x1b[0m')
red = $(shell echo -e '\x1b[33;31m$1\x1b[0m')

.PHONY: help
help: help/clean
	@exit 0

HELP_FILTER ?= .*help

## Help screen
help/clean:
	@printf "Available targets:\n\n"
	@$(MAKE) -s help/generate | grep -v -E "\w($(HELP_FILTER))"

## Display help for all targets
help/all:
	@printf "All Available targets:\n\n"
	@$(MAKE) -s help/generate

# Generate help output from MAKEFILE_LIST
help/generate:
	@awk '/^[-a-zA-Z_0-9%:\\\.\/]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = $$1; \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			gsub("\\\\", "", helpCommand); \
			gsub(":+$$", "", helpCommand); \
			printf "  \x1b[32;01m%-35s\x1b[0m %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort -u
	@printf "\n"

# Generate all help documents in MARDOWN
help/doc:
	@printf "## Make\n\n" > Makefile.md
	@printf '```' >> Makefile.md
	@printf "\nAvailable targets:\n\n" >> Makefile.md
	@$(MAKE) -s help/generate-no-colour | grep -v -E "\w($(HELP_FILTER))" >> Makefile.md
	@printf '```' >> Makefile.md

# Generate help output from MAKEFILE_LIST
help/generate-no-colour:
	@awk '/^[-a-zA-Z_0-9%:\\\.\/]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = $$1; \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			gsub("\\\\", "", helpCommand); \
			gsub(":+$$", "", helpCommand); \
			printf "  %-35s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST) | sort -u
	@printf "\n"

.PHONY: fix/makefiles
## Find all Makefile files and display their contents
fix/makefiles:
	@find . -name "Makefile" -exec cat -e -t -v {} \;
	@find . -name "*.mk" -exec cat -e -t -v {} \;
