# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

.PHONY: checkov/run
## Run Checkov
checkov/run:
	checkov --directory .

.PHONY: checkov/install
## Install Checkov
checkov/install:
	@pip3 install --upgrade --user checkov

.PHONY: checkov/version
## Display checkov version
checkov/version:
	@echo "--- CHECKOV ---"
	@checkov --version
