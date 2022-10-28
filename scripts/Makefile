export WORKSPACE=$(shell pwd)
export HABITS = $(WORKSPACE)/habits

include $(WORKSPACE)/tools.env
#include $(WORKSPACE)/dev.env # don't store secrets in git
#include $(WORKSPACE)/dev.secrets.env # remember to add *.secrets.env to .gitignore

include $(HABITS)/lib/make/Makefile
include $(HABITS)/lib/make/*/Makefile