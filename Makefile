export WORKSPACE=$(shell pwd)
export HABITS = $(WORKSPACE)

include $(WORKSPACE)/tools.env

include $(HABITS)/lib/make/Makefile
include $(HABITS)/lib/make/*/Makefile

.PHONY: dev/post-start
dev/post-start:
	@clear && figlet 'AWS Code Habits'
	@devcontainer-info

.PHONY: hygiene
hygiene: doc/build pre-commit/run
