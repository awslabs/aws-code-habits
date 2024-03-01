.PHONY: github/actions/init
## Initialize .github/actions directory
github/actions/init: ansible/playbooks/github/actions/init

.PHONY: github/issues/init
## Initialize .github/issues directory
github/issues/init: ansible/playbooks/github/issues/init

.PHONY: github/pull-request/init
## Initialize .github/pull-request directory
github/pull-request/init: ansible/playbooks/github/pull-request/init

.PHONY: github/workflows/init
## Initialize .github/workflows directory
github/workflows/init: ansible/playbooks/github/workflows/init
