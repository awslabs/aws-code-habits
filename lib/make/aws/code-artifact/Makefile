# Don't forget to export the following environment variables
# export AWS_CODE_ARTIFACT_REPOSITORY=
# export AWS_CODE_ARTIFACT_OWNER=
# export AWS_CODE_ARTIFACT_DOMAIN=

.PHONY: aws/codeartifact/login
## Login into AWS CodeArtifact
aws/codeartifact/login:
	$(call assert-set,AWS_PROFILE)
	$(call assert-set,AWS_CODE_ARTIFACT_REPOSITORY)
	$(call assert-set,AWS_CODE_ARTIFACT_OWNER)
	$(call assert-set,AWS_CODE_ARTIFACT_DOMAIN)
	@aws --profile $(AWS_PROFILE) codeartifact login --tool npm --repository $(AWS_CODE_ARTIFACT_REPOSITORY) --domain $(AWS_CODE_ARTIFACT_DOMAIN) --domain-owner $(AWS_CODE_ARTIFACT_OWNER)
