.PHONY: aws/sts/get-caller-identity
## Get caller identity
aws/sts/get-caller-identity:
	aws sts get-caller-identity

.PHONY: aws/sts/assume-role
## Assume role
aws/sts/assume-role:
	aws sts assume-role --role-arn <role-arn> --role-session-name <session-name>

.PHONY: aws/sts/get-session-token
## Get session token
aws/sts/get-session-token:
	aws sts get-session-token --duration-seconds <duration-seconds>

.PHONY: aws/sts/refresh-session-token
## Refresh session token
aws/sts/refresh-session-token:
	aws sts refresh-session-token --duration-seconds <duration-seconds> --serial-number <serial-number> --token-code <token-code>

.PHONY: aws/sts/delete-session-token
## Delete session token
aws/sts/delete-session-token:
	aws sts delete-session-token

.PHONY: aws/sts/describe-caller-identity
## Describe caller identity
aws/sts/describe-caller-identity:
	aws sts get-caller-identity --output json
