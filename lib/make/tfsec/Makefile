# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

TFSEC_VERSION?=1.15.2

.PHONY: tfsec/install
## Install TFSEC
tfsec/install:
	@mkdir -p /tmp/download \
	&& wget https://github.com/aquasecurity/tfsec/releases/download/v$(TFSEC_VERSION)/tfsec-linux-amd64 -O /tmp/download/tfsec --quiet --no-check-certificate \
	&& chmod +x /tmp/download/tfsec \
	&& sudo mv /tmp/download/tfsec /usr/local/bin/ \
	&& rm -rf /tmp/download
	@echo "tfsec installed successfully!"
	@$(MAKE) --no-print-directory tfsec/version

.PHONY: tfsec/run
## Run TFSEC
tfsec/run:
	@tfsec .

.PHONY: tfsec/version
## Display TFSEC version
tfsec/version:
	@echo "--- TFSEC ---"
	@tfsec --version
