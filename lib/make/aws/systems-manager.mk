.PHONY: aws/ssm/install-plugin
## Install AWS SSM plugin
aws/ssm/install-plugin:
	mkdir -p /tmp/download \
	&& cd /tmp/download \
	&& curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" \
	&& sudo dpkg -i session-manager-plugin.deb \
	&& rm -rf /tmp/download

.PHONY: aws/ssm/start-session
## Start session with AWS Systems Manager Session Manager
aws/ssm/start-session:
	$(call assert-set,INSTANCE_ID)
	aws --profile $(AWS_PROFILE) ssm start-session --target $(INSTANCE_ID)

.PHONY: aws/ssm/port-forwarding
aws/ssm/port-forwarding:
	$(call assert-set,INSTANCE_ID)
	$(call assert-set,ENDPOINT)
	$(call assert-set,REMOTE_PORT)
	$(call assert-set,LOCAL_PORT)
	aws --profile $(AWS_PROFILE) ssm start-session --target $(INSTANCE_ID) --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "{\"host\":[\"$(ENDPOINT)\"],\"portNumber\":[\"$(REMOTE_PORT)\"],\"localPortNumber\":[\"$(LOCAL_PORT)\"]}"

.PHONY: aws/ssm/list-bastion-instances
aws/ssm/list-bastion-instances:
	aws --profile $(AWS_PROFILE) ec2 describe-instances \
		--filter "Name=tag:bastion,Values=true" \
		--query "Reservations[].Instances[?State.Name == 'running'].InstanceId[]" \
		--output text
