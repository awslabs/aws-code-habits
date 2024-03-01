.PHONY: aws/cognito/list-user-pools
aws/cognito/list-user-pools:
	@aws cognito-idp list-user-pools --max-results 10

.PHONY: aws/cognito/delete-user-pools
aws/cognito/delete-user-pools:
	@. .venv/bin/activate && python3 $(WORKSPACE)/scripts/aws/aws-cognito-delete-user-pools.py

.PHONY: aws/cognito/describe-user-pool
aws/cognito/describe-user-pool:
	@aws cognito-idp describe-user-pool --user-pool-id $(AWS_COGNITO_USER_POOL_ID)

.PHONY: aws/cognito/list-identity-pools
aws/cognito/list-identity-pools:
	@aws cognito-identity list-identity-pools --max-results 10

.PHONY: aws/cognito/user-pool/list-users
aws/cognito/user-pool/list-users:
	@aws cognito-idp list-users --user-pool-id $(AWS_COGNITO_USER_POOL_ID)
