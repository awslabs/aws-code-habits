# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

TERRAFORM_DOCS_VERSION?=0.16.0

.PHONY: terraform-docs/install
## Install terraform-docs
terraform-docs/install:
	@mkdir -p /tmp/download /tmp/extract \
	&& wget https://github.com/terraform-docs/terraform-docs/releases/download/v$(TERRAFORM_DOCS_VERSION)/terraform-docs-v$(TERRAFORM_DOCS_VERSION)-linux-amd64.tar.gz -O /tmp/download/terraform-docs-$(TERRAFORM_DOCS_VERSION)-linux-amd64.tar.gz --quiet --no-check-certificate \
	&& tar -C /tmp/extract -xzf /tmp/download/terraform-docs-$(TERRAFORM_DOCS_VERSION)-linux-amd64.tar.gz \
	&& sudo mv /tmp/extract/terraform-docs /usr/local/bin/ \
	&& rm -rf /tmp/download /tmp/extract
	@echo "terraform-docs installed successfully!"
	@$(MAKE) --no-print-directory terraform-docs/version

.PHONY: terraform-docs/build
## Build doc/terraform-docs.md with Terraform Docs
terraform-docs/build:
ifneq ($(wildcard *.tf),)
	@echo "# Terraform" > Terraform.md
	@terraform-docs markdown . >> Terraform.md
endif

.PHONY: terraform-docs/version
## Display Terraform Docs version
terraform-docs/version:
	@echo "--- TERRAFORM DOCS ---"
	@terraform-docs --version
