.PHONY: aws/sso/login
## Login into AWS account and export credentials to ~/.aws/credentials
aws/sso/login:
	$(call assert-set,AWS_PROFILE)
	@aws sso login --profile $(AWS_PROFILE)
	@sleep 2
	@ssocreds -p $(AWS_PROFILE)
