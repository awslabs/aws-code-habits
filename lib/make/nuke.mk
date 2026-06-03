# NOTE: aws-nuke moved upstream from rebuy-de/aws-nuke (unmaintained) to
# ekristen/aws-nuke. v3.x tarballs ship a plain `aws-nuke` binary at the
# root of the archive (rather than the versioned filename used by v2.x).
.PHONY: nuke/install
nuke/install:
	$(call assert-set,AWS_NUKE_VERSION)
	wget https://github.com/ekristen/aws-nuke/releases/download/$(AWS_NUKE_VERSION)/aws-nuke-$(AWS_NUKE_VERSION)-linux-amd64.tar.gz
	tar -xzf aws-nuke-$(AWS_NUKE_VERSION)-linux-amd64.tar.gz aws-nuke
	sudo mv aws-nuke /usr/local/bin/aws-nuke
	rm -rf aws-nuke-$(AWS_NUKE_VERSION)-linux-amd64.tar.gz

.PHONY: nuke/version
nuke/version:
	aws-nuke version

.PHONY: nuke/list-resource-types
nuke/list-resource-types:
	aws-nuke resource-types

.PHONY: nuke/run
nuke/run:
	$(call confirm,aws-nuke will permanently delete AWS resources matching the config)
	aws-nuke --config $(WORKSPACE)/packages/infra/nuke-config.yaml --no-dry-run --force --force-sleep 3

.PHONY: nuke/dry-run
nuke/dry-run:
	aws-nuke --config $(WORKSPACE)/packages/infra/nuke-config.yaml
