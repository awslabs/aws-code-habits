# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

# NOTE: tfsec is being deprecated by Aqua in favor of Trivy
# (https://github.com/aquasecurity/trivy). Consider migrating.

TFSEC_VERSION?=1.28.14

.PHONY: tfsec/install
## Install TFSEC
tfsec/install:
	@mkdir -p /tmp/download \
	&& wget --https-only --quiet https://github.com/aquasecurity/tfsec/releases/download/v$(TFSEC_VERSION)/tfsec-linux-amd64 -O /tmp/download/tfsec \
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
