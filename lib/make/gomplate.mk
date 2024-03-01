# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

GOMPLATE_VERSION?=3.10.0

.PHONY: gomplate/install
gomplate/install:
	@mkdir -p /tmp/download \
	&& wget https://github.com/hairyhenderson/gomplate/releases/download/v$(GOMPLATE_VERSION)/gomplate_linux-amd64-slim -O /tmp/download/gomplate --quiet --no-check-certificate \
	&& chmod +x /tmp/download/gomplate \
	&& sudo mv /tmp/download/gomplate /usr/local/bin/ \
	&& rm -rf /tmp/download
	@echo "gomplate installed successfully!"
	@$(MAKE) --no-print-directory gomplate/version

.PHONY: gomplate/version
## Display Gomplate version
gomplate/version:
	@echo "--- GOMPLATE ---"
	@gomplate --version
