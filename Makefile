export WORKSPACE=$(shell pwd)
export HABITS = $(WORKSPACE)

include $(WORKSPACE)/.env

include $(HABITS)/lib/make/Makefile
include $(HABITS)/lib/make/*/Makefile

.PHONY: dev/post-start
dev/post-start:
	@$(MAKE) --no-print-directory habits/install
	@$(MAKE) --no-print-directory aws/cli/install aws/config/init
	@$(MAKE) --no-print-directory npm/aws-sso-creds-helper/install
	@clear && figlet 'AWS Code Habits'
	@devcontainer-info

.PHONY: hygiene
hygiene: doc/build pre-commit/run
