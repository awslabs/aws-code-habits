# Expected folder structure
# └── infrastructure
#     └── mystack
#         ├── parameters
#         │   └── dev.json
#         └── template.yml

.PHONY: aws/cloudformation/create-folder-structure
## Create a folder structure for CloudFormation projects
aws/cloudformation/create-folder-structure:
	$(call assert-set,STACK_NAME_PREFIX)
	@mkdir -p infrastructure/$(STACK_NAME_PREFIX)/parameters

.PHONY: aws/cloudformation/create-template-yaml
## Copy a CloudFormation template to be used as example
aws/cloudformation/create-template-yaml:
	$(call assert-set,STACK_NAME_PREFIX)
	@cp $(HABITS)/files/aws/cloudformation/template.yml infrastructure/$(STACK_NAME_PREFIX)/template.yml

.PHONY: aws/cloudformation/create-parameters
## Copy a CloudFormation parameters to be used as example
aws/cloudformation/create-parameters:
	$(call assert-set,STACK_NAME_PREFIX)
	$(call assert-set,ENVIRONMENT)
	@cp $(HABITS)/files/aws/cloudformation/parameters.json infrastructure/$(STACK_NAME_PREFIX)/parameters/$(ENVIRONMENT).json

.PHONY: aws/cloudformation/create-project
## Create a CloudFormation project structure
aws/cloudformation/create-project: \
	aws/cloudformation/create-folder-structure \
	aws/cloudformation/create-template-yaml \
	aws/cloudformation/create-parameters

STACK_ENVIRONMENT_NAME ?= $(STACK_NAME_PREFIX)-$(ENVIRONMENT)

# Generate random unique 4-letter identifier
CHANGE_SET_ID:=$(shell openssl rand -hex 4)
CHANGE_SET_NAME ?= $(STACK_ENVIRONMENT_NAME)-$(CHANGE_SET_ID)

.PHONY: aws/cloudformation/assert/variables
aws/cloudformation/assert/variables:
	$(call assert-set,INFRASTRUCTURE)
	$(call assert-set,TEMPLATE)
	$(call assert-set,STACK_NAME_PREFIX)
	$(call assert-set,ENVIRONMENT)
	$(call assert-set,PARAMETERS)
	@echo "-------------------------"
	@echo "INFRASTRUCTURE: $(INFRASTRUCTURE)"
	@echo "TEMPLATE: $(TEMPLATE)"
	@echo "STACK_NAME_PREFIX: $(STACK_NAME_PREFIX)"
	@echo "ENVIRONMENT: $(ENVIRONMENT)"
	@echo "PARAMETERS: $(PARAMETERS)"
	@echo "STACK_ENVIRONMENT_NAME: $(STACK_ENVIRONMENT_NAME)"
	@echo "-------------------------"

.PHONY: aws/cloudformation/assert/variables-without-parameters
aws/cloudformation/assert/variables-without-parameters:
	$(call assert-set,INFRASTRUCTURE)
	$(call assert-set,TEMPLATE)
	$(call assert-set,STACK_NAME_PREFIX)
	$(call assert-set,ENVIRONMENT)
	@echo "-------------------------"
	@echo "INFRASTRUCTURE: $(INFRASTRUCTURE)"
	@echo "TEMPLATE: $(TEMPLATE)"
	@echo "STACK_NAME_PREFIX: $(STACK_NAME_PREFIX)"
	@echo "ENVIRONMENT: $(ENVIRONMENT)"
	@echo "STACK_ENVIRONMENT_NAME: $(STACK_ENVIRONMENT_NAME)"
	@echo "-------------------------"

.PHONY: aws/cloudformation/create-stack
## Creates a stack as specified in the template.
aws/cloudformation/create-stack: aws/cloudformation/assert/variables
	@echo "Creating Stack $(STACK_ENVIRONMENT_NAME)"
	@aws --profile $(AWS_PROFILE) --profile $(AWS_PROFILE) --profile $(AWS_PROFILE) cloudformation create-stack \
		--stack-name $(STACK_ENVIRONMENT_NAME) \
		--template-body file://infrastructure/$(INFRASTRUCTURE)/$(TEMPLATE).yml \
		--parameters file://infrastructure/$(INFRASTRUCTURE)/params/$(PARAMETERS).json \
		--capabilities CAPABILITY_IAM
	@echo "Waiting for stack $(STACK_ENVIRONMENT_NAME) to be created ..."
	@aws --profile $(AWS_PROFILE) cloudformation wait stack-create-complete --stack-name $(STACK_ENVIRONMENT_NAME)
	@echo "CloudFormation stack $(STACK_ENVIRONMENT_NAME) created successfully"
	@$(MAKE) --no-print-directory aws/cloudformation/display-stack-events

.PHONY: aws/cloudformation/display-stack-events
aws/cloudformation/display-stack-events:
	$(call assert-set,AWS_PROFILE)
	$(call assert-set,STACK_ENVIRONMENT_NAME)
	$(call assert-set,AWS_DEFAULT_REGION)
	$(call assert-set,STACK_ID)
	$(eval STACK_ID := $(shell aws --profile $(AWS_PROFILE) cloudformation describe-stacks --stack-name $(STACK_ENVIRONMENT_NAME) --query 'Stacks[*].[StackId]' --output text))
	@echo "-------------------------"
	@echo -e '\e]8;;https://$(AWS_DEFAULT_REGION).console.aws.amazon.com/cloudformation/home?region=$(AWS_DEFAULT_REGION)#/stacks/events?stackId=$(STACK_ID)&filteringStatus=active&filteringText=&viewNested=true&hideStacks=true\aView Stack Events\e]8;;\a'

.PHONY: aws/cloudformation/create-stack-without-parameters
## Creates a stack as specified in the template. (don't pass --parameters flag)
aws/cloudformation/create-stack-without-parameters: aws/cloudformation/assert/variables-without-parameters
	@echo "Creating Stack $(STACK_ENVIRONMENT_NAME)"
	@aws --profile $(AWS_PROFILE) cloudformation create-stack \
		--stack-name $(STACK_ENVIRONMENT_NAME) \
		--template-body file://infrastructure/$(INFRASTRUCTURE)/$(TEMPLATE).yml \
		--capabilities CAPABILITY_IAM
	@echo "Waiting for stack $(STACK_ENVIRONMENT_NAME) to be created ..."
	@aws --profile $(AWS_PROFILE) cloudformation wait stack-create-complete --stack-name $(STACK_ENVIRONMENT_NAME)
	@echo "CloudFormation stack $(STACK_ENVIRONMENT_NAME) created successfully"
	@$(MAKE) --no-print-directory aws/cloudformation/display-stack-events

.PHONY: aws/cloudformation/create/service-linked-role
## Creates  an  IAM  role that is linked to a specific Amazon Elasticsearch service.
aws/cloudformation/create/service-linked-role:
	$(call assert-set,SERVICE_NAME)
	@aws iam create-service-linked-role --aws-service-name $(SERVICE_NAME)

.PHONY: aws/cloudformation/describe-stack-events
## Returns  all  stack  related  events  for  a specified stack in reverse chronological order.
aws/cloudformation/describe-stack-events: aws/cloudformation/assert/variables
	@aws --profile $(AWS_PROFILE) cloudformation describe-stack-events --stack-name $(STACK_ENVIRONMENT_NAME)

.PHONY: aws/cloudformation/describe-stack
## Returns  the  description for the specified stack; if no stack name was specified, then it returns the description for all the stacks created.
aws/cloudformation/describe-stack: aws/cloudformation/assert/variables
	@aws --profile $(AWS_PROFILE) cloudformation describe-stacks --stack-name $(STACK_ENVIRONMENT_NAME)

.PHONY: aws/cloudformation/delete/service-linked-role
## Deletes  an  IAM  role that is linked to a specific Amazon Web Services service.
aws/cloudformation/delete/service-linked-role:
	$(call assert-set,SERVICE_NAME)
	@aws iam delete-service-linked-role --role-name $(SERVICE_NAME)

.PHONY: aws/cloudformation/hygiene
## Execute CFN Lint and pre-commit rules
aws/cloudformation/hygiene:
	$(call assert-set,INFRASTRUCTURE)
	@cfn-lint infrastructure/$(INFRASTRUCTURE)/*.yml
	@$(MAKE) --no-print-directory pre-commit/run

.PHONY: aws/cloudformation/create-change-set
## Creates a list of changes that will be applied to a stack so that you can review the changes before executing them.
aws/cloudformation/create-change-set: aws/cloudformation/assert/variables
	@echo "Creating Change Set $(CHANGE_SET_NAME)"
	$(eval CHANGE_SET := $(shell aws --profile $(AWS_PROFILE) cloudformation create-change-set \
		--stack-name $(STACK_ENVIRONMENT_NAME) \
		--template-body file://infrastructure/$(INFRASTRUCTURE)/$(TEMPLATE).yml \
		--parameters file://infrastructure/$(INFRASTRUCTURE)/params/$(PARAMETERS).json \
		--capabilities CAPABILITY_IAM \
		--change-set-name $(CHANGE_SET_NAME) \
		--output text \
		))
	@sleep 5
	@echo "Waiting for Change Set $(CHANGE_SET_NAME) to be created"
	@aws --profile $(AWS_PROFILE) cloudformation wait change-set-create-complete \
		--stack-name $(STACK_ENVIRONMENT_NAME) \
		--change-set-name $(CHANGE_SET_NAME)
	@echo "Change Set $(CHANGE_SET_NAME) created successfully"
	@echo "-------------------------"
	$(eval STACK_ID := $(shell echo $(CHANGE_SET) | awk '{print $$2}'))
	$(eval CHANGE_SET_ID := $(shell echo $(CHANGE_SET) | awk '{print $$1}'))
	@echo -e '\e]8;;https://$(AWS_DEFAULT_REGION).console.aws.amazon.com/cloudformation/home?region=$(AWS_DEFAULT_REGION)#/stacks/changesets/changes?stackId=$(STACK_ID)&changeSetId=$(CHANGE_SET_ID)\aView Change Set\e]8;;\a'

.PHONY: aws/cloudformation/show-latest-change-set
aws/cloudformation/show-latest-change-set:
	$(call assert-set,AWS_DEFAULT_REGION)
	$(call assert-set,STACK_ID)
	$(call assert-set,CHANGE_SET_ID)
	$(eval STACK_ID := $(shell grep '"StackId":' /tmp/change-set | awk '{print $$2}' | sed s/,//g | sed s,\",,g))
	$(eval CHANGE_SET_ID := $(shell grep '"Id":' /tmp/change-set | awk '{print $$2}' | sed s/,//g | sed s,\",,g))
	@echo "-------------------------"
	@echo -e '\e]8;;https://$(AWS_DEFAULT_REGION).console.aws.amazon.com/cloudformation/home?region=$(AWS_DEFAULT_REGION)#/stacks/changesets/changes?stackId=$(STACK_ID)&changeSetId=$(CHANGE_SET_ID)\aView Change Set\e]8;;\a'

.PHONY: aws/cloudformation/create-change-set-without-parameters
## Creates a list of changes that will be applied to a stack so that you can review the changes before executing them.
aws/cloudformation/create-change-set-without-parameters: aws/cloudformation/assert/variables-without-parameters
	@echo "Creating Change Set $(CHANGE_SET_NAME)"
	@aws --profile $(AWS_PROFILE) cloudformation create-change-set \
		--stack-name $(STACK_ENVIRONMENT_NAME) \
		--template-body file://infrastructure/$(INFRASTRUCTURE)/$(TEMPLATE).yml \
		--capabilities CAPABILITY_IAM \
		--change-set-name $(CHANGE_SET_NAME)
	@echo "Waiting for Change Set $(CHANGE_SET_NAME) to be created"
	@aws --profile $(AWS_PROFILE) cloudformation wait change-set-create-complete \
		--stack-name $(STACK_ENVIRONMENT_NAME) \
		--change-set-name $(CHANGE_SET_NAME)
	@echo "Change Set $(CHANGE_SET_NAME) created successfully"

.PHONY: aws/cloudformation/delete-change-set
## Delete latest change-set created
aws/cloudformation/delete-change-set: aws/cloudformation/assert/variables
	@echo "Deleting latest Change Set"
	@$(MAKE) --no-print-directory aws/cloudformation/latest-change-set \
	| xargs aws --profile $(AWS_PROFILE) cloudformation delete-change-set --stack-name $(STACK_ENVIRONMENT_NAME) --change-set-name

.PHONY: aws/cloudformation/execute-change-set
## Execute latest change-set
aws/cloudformation/execute-change-set: aws/cloudformation/assert/variables
	@echo "Executing latest Change Set"
	$(eval CHANGE_SET_NAME := $(shell $(MAKE) --no-print-directory aws/cloudformation/latest-change-set))
	@aws --profile $(AWS_PROFILE) cloudformation execute-change-set --stack-name $(STACK_ENVIRONMENT_NAME) --change-set-name $(CHANGE_SET_NAME)
	@$(MAKE) --no-print-directory aws/cloudformation/display-stack-events

.PHONY: aws/cloudformation/latest-change-set
## Display latest change-set
aws/cloudformation/latest-change-set:
	$(call assert-set,AWS_PROFILE)
	$(call assert-set,STACK_ENVIRONMENT_NAME)
	@aws --profile $(AWS_PROFILE) cloudformation list-change-sets \
		--stack-name $(STACK_ENVIRONMENT_NAME) \
		--query 'Summaries[*].[CreationTime, ChangeSetName]' \
		--output text | sort -rk1 | head -n 1 | awk '{print $$2}'

.PHONY: aws/cloudformation/estimate-template-cost
## Returns  the  estimated monthly cost of a template
aws/cloudformation/estimate-template-cost: aws/cloudformation/assert/variables
	@echo "Template Cost Estimation"
	@aws --profile $(AWS_PROFILE) cloudformation estimate-template-cost \
		--template-body file://infrastructure/$(INFRASTRUCTURE)/$(TEMPLATE).yml \
		--parameters file://infrastructure/$(INFRASTRUCTURE)/params/$(PARAMETERS).json \

.PHONY: aws/cloudformation/detect-stack-drift
## Detects  whether a stack's actual configuration differs, or has drifted , from it's expected configuration, as defined in  the  stack  template and  any  values specified as template parameters.
aws/cloudformation/detect-stack-drift: aws/cloudformation/assert/variables
	@aws/cloudformation/aws --profile $(AWS_PROFILE) cloudformation detect-stack-drift \
		--stack-name $(STACK_ENVIRONMENT_NAME) \

.PHONY: aws/cloudformation/validate-template
aws/cloudformation/validate-template:
	$(call assert-set,AWS_PROFILE)
	$(call assert-set,INFRASTRUCTURE)
	$(call assert-set,TEMPLATE)
	@echo "Validate Template"
	@aws --profile $(AWS_PROFILE) cloudformation validate-template \
		--template-body file://infrastructure/$(INFRASTRUCTURE)/$(TEMPLATE).yml \
		--output yaml

.PHONY: aws/cloudformation/delete-stack
## Delete CloudFormation Stack
aws/cloudformation/delete-stack: aws/cloudformation/assert/variables-without-parameters
	@echo "Delete Stack $(STACK_ENVIRONMENT_NAME)"
	@echo Warning: Continue? [Y/n]
	@read line; if [ $$line = "n" ]; then echo aborting; exit 1 ; fi
	@aws --profile $(AWS_PROFILE) cloudformation delete-stack --stack-name $(STACK_ENVIRONMENT_NAME)
	@sleep 5
	@echo "Waiting for stack $(STACK_ENVIRONMENT_NAME) to be deleted ..."
	@aws --profile $(AWS_PROFILE) cloudformation wait stack-delete-complete --stack-name $(STACK_ENVIRONMENT_NAME)
