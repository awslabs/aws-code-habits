# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# Safety guards for destructive Make targets.
#
# Usage in a recipe:
#   $(call confirm,terraform/destroy will permanently destroy ALL infrastructure)
#
# To skip the prompt (e.g., CI), set CONFIRM=yes:
#   make terraform/destroy CONFIRM=yes
#
# The macro reads from /dev/tty so it works inside chained shell pipelines.

CONFIRM ?=

define confirm
	@if [ "$(CONFIRM)" != "yes" ]; then \
		printf "\033[33mWARNING:\033[0m %s\n" "$(1)"; \
		printf "Type 'yes' to continue, anything else to abort: "; \
		read REPLY < /dev/tty; \
		if [ "$$REPLY" != "yes" ]; then \
			echo "Aborted."; \
			exit 1; \
		fi; \
	else \
		echo "CONFIRM=yes set — skipping interactive prompt."; \
	fi
endef
