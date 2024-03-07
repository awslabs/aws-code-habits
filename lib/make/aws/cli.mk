# aws-sso-creds-helper:
# When using aws sso login on AWS CLI v2 as of July 27th, 2020,
# the credentials are stored so they will work with the CLI itself (v2) but don't work on the AWS SDKs and other tools that expect credentials to be readable from ~/.aws/credentials (v1).
# This package aims to streamline updating the AWS credentials file for AWS SSO users by updating/creating the corresponding profile section in ~/.aws/credentials with temporary role credentials.

.PHONY: aws/cli/install
## Install AWS Command Line Interface v2
aws/cli/install: aws/cli/install/v2 aws/cli/autocomplete

.PHONY:aws/cli/install/v2
aws/cli/install/v2:
	@mkdir -p /tmp/awscli ;\
	cd /tmp/awscli ;\
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" --silent -o "awscliv2.zip" ;\
	unzip -qq awscliv2.zip ;\
	sudo ./aws/install ;\
	rm -rf /tmp/awscli ;\

.PHONY: aws/cli/autocomplete
aws/cli/autocomplete:
	@echo "complete -C '/usr/local/bin/aws_completer' aws" | tee --append ~/.bashrc
	@echo "complete -C '/usr/local/bin/aws_completer' aws" | tee --append ~/.zshrc

.PHONY: aws/cli/install/sso-creds-helper
aws/cli/install/sso-creds-helper:
	npm install -g aws-sso-creds-helper

.PHONY: aws/cli/version
## Display AWS CLI version
aws/cli/version:
	@echo "--- AWS CLI ---"
	@aws --version
