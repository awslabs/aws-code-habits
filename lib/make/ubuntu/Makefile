.PHONY: ubuntu/install-packages
## Install most common packages
ubuntu/install-packages:
	@sudo apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && sudo apt-get -y install \
	bash-completion \
	ca-certificates \
	curl \
	curl \
	expect \
	figlet \
	gawk \
	git \
	git-flow \
	gnupg \
	jq \
	less \
	make \
	nodejs \
	openssh-server \
	python3-pip \
	software-properties-common \
	ssh \
	tree \
	tzdata \
	unzip \
	vim \
	wget
	@sudo update-ca-certificates

.PHONY: ubuntu/update
## Update and upgrade Ubuntu packages
ubuntu/update: ansible/playbooks/ubuntu/update
