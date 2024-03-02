.PHONY: ubuntu/install
## Install most common packages
ubuntu/install: ansible/playbooks/ubuntu/install

.PHONY: ubuntu/update
## Update and upgrade Ubuntu packages
ubuntu/update: ansible/playbooks/ubuntu/update

.PHONY: ubuntu/version
ubuntu/version:
	@lsb_release -a
