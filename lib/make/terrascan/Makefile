# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

TERRASCAN_VERSION?=1.13.2

.PHONY: terrascan/install
## Install terrascan
terrascan/install:
	@mkdir -p /tmp/download /tmp/extract \
	&& wget https://github.com/accurics/terrascan/releases/download/v$(TERRASCAN_VERSION)/terrascan_$(TERRASCAN_VERSION)_Linux_x86_64.tar.gz -O /tmp/download/terrascan_$(TERRASCAN_VERSION)_Linux_x86_64.tar.gz --quiet --no-check-certificate \
	&& sha256sum /tmp/download/terrascan_$(TERRASCAN_VERSION)_Linux_x86_64.tar.gz \
	&& tar -C /tmp/extract -xzf /tmp/download/terrascan_$(TERRASCAN_VERSION)_Linux_x86_64.tar.gz \
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
