.PHONY: nuke/install
nuke/install:
	$(call assert-set,AWS_NUKE_VERSION)
	wget https://github.com/rebuy-de/aws-nuke/releases/download/$(AWS_NUKE_VERSION)/aws-nuke-$(AWS_NUKE_VERSION)-linux-amd64.tar.gz
	tar -xzf aws-nuke-$(AWS_NUKE_VERSION)-linux-amd64.tar.gz
	sudo mv aws-nuke-$(AWS_NUKE_VERSION)-linux-amd64 /usr/local/bin/aws-nuke
	rm -rf aws-nuke-$(AWS_NUKE_VERSION)-linux-amd64.tar.gz

.PHONY: nuke/version
nuke/version:
	aws-nuke version

.PHONY: nuke/list-resource-types
nuke/list-resource-types:
	aws-nuke resource-types

.PHONY: nuke/run
nuke/run:
	aws-nuke --config $(WORKSPACE)/packages/infra/nuke-config.yaml --no-dry-run --force --force-sleep 3

.PHONY: nuke/dry-run
nuke/dry-run:
	aws-nuke --config $(WORKSPACE)/packages/infra/nuke-config.yaml
