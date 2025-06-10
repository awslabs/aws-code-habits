.PHONY: aws/amplify/install
## Install AWS Amplify CLI on Ubuntu 22.04
aws/amplify/install:
	sudo apt-get update
	sudo apt-get install -y nodejs npm
	sudo npm install -g @aws-amplify/cli

.PHONY: aws/amplify/init
## Initialize a new Amplify project
aws/amplify/init:
	amplify init

.PHONY: aws/amplify/add-analytics
## Add an AWS resource to the project
aws/amplify/add-analytics:
	amplify add analytics
.PHONY: aws/amplify/add-api

aws/amplify/add-api:
	amplify add api
.PHONY: aws/amplify/add-auth

aws/amplify/add-auth:
	amplify add auth
.PHONY: aws/amplify/add-hosting

aws/amplify/add-hosting:
	amplify add hosting
.PHONY: aws/amplify/add-storage

aws/amplify/add-storage:
	amplify add storage

.PHONY: aws/amplify/push
## Push local changes to the Amplify environment
aws/amplify/push:
	amplify push

.PHONY: aws/amplify/deploy
## Deploy amplify hosting resources
aws/amplify/deploy:
	amplify hosting deploy

.PHONY: aws/amplify/remove
## Remove Amplify resources
aws/amplify/remove:
	amplify remove

.PHONY: aws/amplify/console
## Open the Amplify Console for the project
aws/amplify/console:
	amplify console

.PHONY: aws/amplify/status
## Check the status of the Amplify project
aws/amplify/status:
	amplify status

.PHONY: aws/amplify/list
## List available Amplify resources in the project
aws/amplify/list:
	amplify status

.PHONY: aws/amplify/codegen
## Generate code for the Amplify resources
aws/amplify/codegen:
	amplify codegen

.PHONY: aws/amplify/configure
## Configure Amplify project settings
aws/amplify/configure:
	amplify configure

.PHONY: aws/amplify/edit
## View or edit the current Amplify project
aws/amplify/edit:
	amplify edit

.PHONY: aws/amplify/docs
## Open the Amplify documentation
aws/amplify/docs:
	@python -m webbrowser -t https://docs.amplify.aws

.PHONY: aws/amplify/clean
## Clean up any generated files or build artifacts
aws/amplify/clean:
	rm -rf amplify/.temp
	rm -rf src/generated-models
	rm -rf src/generated-graphql
	rm -rf dist
