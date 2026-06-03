# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

TERRASCAN_VERSION?=1.19.9
TERRASCAN_SHA256?=
# TODO pin sha256 from https://github.com/tenable/terrascan/releases/download/v${TERRASCAN_VERSION}/terrascan_${TERRASCAN_VERSION}_Linux_x86_64.tar.gz.sha256sum

.PHONY: terrascan/install
## Install terrascan
terrascan/install:
	@mkdir -p /tmp/download /tmp/extract
	@wget --https-only --quiet https://github.com/tenable/terrascan/releases/download/v$(TERRASCAN_VERSION)/terrascan_$(TERRASCAN_VERSION)_Linux_x86_64.tar.gz -O /tmp/download/terrascan_$(TERRASCAN_VERSION)_Linux_x86_64.tar.gz
	@if [ -n "$(TERRASCAN_SHA256)" ]; then \
		echo "$(TERRASCAN_SHA256)  /tmp/download/terrascan_$(TERRASCAN_VERSION)_Linux_x86_64.tar.gz" | sha256sum -c -; \
	else \
		echo "WARNING: TERRASCAN_SHA256 not set — skipping checksum verification. Set it for supply-chain safety."; \
	fi
	@tar -C /tmp/extract -xzf /tmp/download/terrascan_$(TERRASCAN_VERSION)_Linux_x86_64.tar.gz \
	&& sudo mv /tmp/extract/terrascan /usr/local/bin/ \
	&& rm -rf /tmp/download /tmp/extract
	@echo "terrascan installed successfully!"
	@$(MAKE) --no-print-directory terrascan/version

.PHONY: terrascan/run
## Run Terrascan
terrascan/run:
	@terrascan scan

.PHONY: terrascan/version
## Display Terrascan version
terrascan/version:
	@echo "--- TERRASCAN ---"
	@terrascan version
