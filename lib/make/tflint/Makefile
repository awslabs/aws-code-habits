# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

TFLINT_AWS_RULESET_VERSION=0.13.4

.PHONY: tflint/install
tflint/install:
	@curl https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
	@echo "tflint installed successfully!"
	@$(MAKE) --no-print-directory tflint/version


.PHONY: tflint/init
## Init AWS TFLINT
tflint/init:
ifeq ($(wildcard $(WORKSPACE)/.tflint.hcl),)
	cp $(HABITS)/files/.tflint.hcl $(WORKSPACE)/.tflint.hcl
	sed -i "s,TFLINT_AWS_RULESET_VERSION,$(TFLINT_AWS_RULESET_VERSION),g" $(WORKSPACE)/.tflint.hcl
	@tflint --init
endif

.PHONY: tflint/run
## Run TFLINT
tflint/run:
	@tflint .

.PHONY: tflint/version
## Display TFLINT version
tflint/version:
	@echo "--- TFLINT ---"
	@tflint --version
