.PHONY: aws/cdk/bootstrap
aws/cdk/bootstrap:
	cd packages/infra && npx cdk bootstrap --verbose

.PHONY: aws/cdk/destroy-bootstrap
aws/cdk/destroy-bootstrap:
	aws cloudformation delete-stack --stack-name CDKToolkit

.PHONY: aws/cdk/install
aws/cdk/install:
	npm install -g aws-cdk
