# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

.PHONY: tfswitch/install
## Install tfswitch
tfswitch/install:
	@curl -L https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | sudo bash
	@echo "tfswitch installed successfully!"
	@$(MAKE) --no-print-directory tfswitch/version


.PHONY: tfswitch/run
## Execute tfswitch
tfswitch/run:
	@tfswitch
	@terraform -version

.PHONY: tfswitch/version
## Display tfswitch version
tfswitch/version:
	@echo "--- TFSWITCH ---"
	@tfswitch --version
