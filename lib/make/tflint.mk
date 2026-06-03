# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

TFLINT_AWS_RULESET_VERSION?=0.47.0
TFLINT_VERSION?=0.63.0
TFLINT_SHA256?=

.PHONY: tflint/install
## Install TFLINT
tflint/install:
	@mkdir -p /tmp/download /tmp/extract
	@wget --quiet \
	  https://github.com/terraform-linters/tflint/releases/download/v$(TFLINT_VERSION)/tflint_linux_amd64.zip \
	  -O /tmp/download/tflint.zip
	@if [ -n "$(TFLINT_SHA256)" ]; then \
	  echo "$(TFLINT_SHA256)  /tmp/download/tflint.zip" | sha256sum -c -; \
	else \
	  echo "WARNING: TFLINT_SHA256 not set — skipping checksum verification. Set it for supply-chain safety."; \
	fi
	@unzip -q -o /tmp/download/tflint.zip -d /tmp/extract
	@sudo mv /tmp/extract/tflint /usr/local/bin/
	@rm -rf /tmp/download /tmp/extract
	@echo "tflint installed successfully!"
	@$(MAKE) --no-print-directory tflint/version

.PHONY: tflint/init
## Init AWS TFLINT
tflint/init:
ifeq ($(wildcard $(WORKSPACE)/.tflint.hcl),)
	@cp $(HABITS)/files/terraform/.tflint.hcl $(WORKSPACE)/.tflint.hcl
	@sed -i "s,TFLINT_AWS_RULESET_VERSION,$(TFLINT_AWS_RULESET_VERSION),g" $(WORKSPACE)/.tflint.hcl
	@tflint --init
endif

.PHONY: tflint/init/force
## Init AWS TFLINT, overwrites the current configuration
tflint/init/force:
	@cp $(HABITS)/files/terraform/.tflint.hcl $(WORKSPACE)/.tflint.hcl
	@sed -i "s,TFLINT_AWS_RULESET_VERSION,$(TFLINT_AWS_RULESET_VERSION),g" $(WORKSPACE)/.tflint.hcl
	@tflint --init

.PHONY: tflint/run
## Run TFLINT
tflint/run:
	@tflint

.PHONY: tflint/version
## Display TFLINT version
tflint/version:
	@echo "--- TFLINT ---"
	@tflint --version
