.PHONY: aws/sts/get-caller-identity
## Returns  details  about the IAM user or role whose credentials are used to call the operation.
aws/sts/get-caller-identity:
	$(call assert-set,AWS_PROFILE)
	@aws --profile $(AWS_PROFILE) sts get-caller-identity
