.PHONY: doc/init
## Initialize documentation
doc/init: ansible/playbooks/doc/init

.PHONY: doc/build
## Builds documentation
doc/build: ansible/playbooks/doc/build
