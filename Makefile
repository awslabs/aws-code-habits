export WORKSPACE=$(shell pwd)
export HABITS = $(WORKSPACE)

include $(WORKSPACE)/tools.env

include $(HABITS)/lib/make/Makefile
include $(HABITS)/lib/make/ansible/Makefile
include $(HABITS)/lib/make/pre-commit/Makefile
include $(HABITS)/lib/make/doc/Makefile

.PHONY: hygiene
hygiene: doc/build pre-commit/run
