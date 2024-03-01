.PHONY: aws/cloudwatch/logs/delete-log-groups-prefix
aws/cloudwatch/logs/delete-log-groups-prefix:
	$(call assert-set,AWS_REGION)
	$(call assert-set,AWS_ACCOUNT_ID)
	@aws logs describe-log-groups --log-group-name-prefix '/aws/lambda/ul-dev-' --query 'logGroups[*].logGroupName' --output text | tr '\t' '\n' | while read log_group; do \
		aws logs delete-log-group --log-group-name $$log_group; \
	done
