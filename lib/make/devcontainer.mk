.PHONY: devcontainer/init
devcontainer/init:
	@sudo apt update
	@sudo apt install --yes make
	@$(MAKE) --no-print-directory \
		ansible/install \
		ansible/playbooks/ubuntu/install
	@sudo update-ca-certificates

.PHONY: devcontainer/terraform/init
devcontainer/terraform/init: devcontainer/init
	@$(MAKE) --no-print-directory \
		aws/cli/install/v2 \
		aws/cli/autocomplete \
		terraform/install \
		terraform-docs/install \
		checkov/install \
		tflint/install \
		tfsec/install \
		tfswitch/install \
		terrascan/install
