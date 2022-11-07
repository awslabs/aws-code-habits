DEFAULT_HELP_TARGET ?= help/clean
HELP_FILTER ?= .*help

green = $(shell echo -e '\x1b[32;01m$1\x1b[0m')
yellow = $(shell echo -e '\x1b[33;01m$1\x1b[0m')
red = $(shell echo -e '\x1b[33;31m$1\x1b[0m')

## Help screen
help/clean:
	@printf "Available targets:\n\n"
	@$(SELF) -s help/generate | grep -v -E "\w($(HELP_FILTER))"

## Display help for all targets
help/all:
	@printf "All Available targets:\n\n"
	@$(SELF) -s help/generate

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
	@$(SELF) -s help/generate-no-colour | grep -v -E "\w($(HELP_FILTER))" >> Makefile.md
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

default:: $(DEFAULT_HELP_TARGET)
	@exit 0
