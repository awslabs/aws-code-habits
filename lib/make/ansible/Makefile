.PHONY: ansible/install
ansible/install:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		pip install --upgrade ansible ;\
	)

.PHONY: ansible/playbooks/aws/config/init
ansible/playbooks/aws/config/init:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		cd $(HABITS)/lib/ansible && ansible-playbook playbooks/aws/config/init.yaml --extra-vars="workspace=$(WORKSPACE) habits=$(HABITS)" ;\
	)

.PHONY: ansible/playbooks/aws/config/remove
ansible/playbooks/aws/config/remove:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		cd $(HABITS)/lib/ansible && ansible-playbook playbooks/aws/config/remove.yaml --extra-vars="workspace=$(WORKSPACE) habits=$(HABITS)" ;\
	)

.PHONY: ansible/playbooks/doc/init
ansible/playbooks/doc/init:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		cd $(HABITS)/lib/ansible && ansible-playbook playbooks/doc/init.yaml --extra-vars="workspace=$(WORKSPACE) habits=$(HABITS)" ;\
	)

.PHONY: ansible/playbooks/doc/build
ansible/playbooks/doc/build:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		cd $(HABITS)/lib/ansible && ansible-playbook playbooks/doc/build.yaml --extra-vars="workspace=$(WORKSPACE) habits=$(HABITS)" --extra-vars=@$(WORKSPACE)/doc/habits.yaml ;\
	)

.PHONY: ansible/playbooks/doc/remove
ansible/playbooks/doc/remove:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		cd $(HABITS)/lib/ansible && ansible-playbook playbooks/doc/remove.yaml --extra-vars="workspace=$(WORKSPACE) habits=$(HABITS)" ;\
	)

.PHONY: ansible/playbooks/github/actions/init
ansible/playbooks/github/actions/init:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		cd $(HABITS)/lib/ansible && ansible-playbook playbooks/github/actions/init.yaml --extra-vars="workspace=$(WORKSPACE) habits=$(HABITS)" ;\
	)

.PHONY: ansible/playbooks/github/actions/remove
ansible/playbooks/github/actions/remove:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		cd $(HABITS)/lib/ansible && ansible-playbook playbooks/github/actions/remove.yaml --extra-vars="workspace=$(WORKSPACE) habits=$(HABITS)" ;\
	)

.PHONY: ansible/playbooks/github/issues/init
ansible/playbooks/github/issues/init:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		cd $(HABITS)/lib/ansible && ansible-playbook playbooks/github/issues/init.yaml --extra-vars="workspace=$(WORKSPACE) habits=$(HABITS)" ;\
	)

.PHONY: ansible/playbooks/github/issues/remove
ansible/playbooks/github/issues/remove:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		cd $(HABITS)/lib/ansible && ansible-playbook playbooks/github/issues/remove.yaml --extra-vars="workspace=$(WORKSPACE) habits=$(HABITS)" ;\
	)

.PHONY: ansible/playbooks/habits/remove
ansible/playbooks/habits/remove:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		cd $(HABITS)/lib/ansible && ansible-playbook playbooks/habits/remove.yaml --extra-vars="workspace=$(WORKSPACE) habits=$(HABITS)" ;\
	)

.PHONY: ansible/playbooks/github/pull-request/init
ansible/playbooks/github/pull-request/init:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		cd $(HABITS)/lib/ansible && ansible-playbook playbooks/github/pull-request/init.yaml --extra-vars="workspace=$(WORKSPACE) habits=$(HABITS)" ;\
	)

.PHONY: ansible/playbooks/github/pull-request/remove
ansible/playbooks/github/pull-request/remove:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		cd $(HABITS)/lib/ansible && ansible-playbook playbooks/github/pull-request/remove.yaml --extra-vars="workspace=$(WORKSPACE) habits=$(HABITS)" ;\
	)

.PHONY: ansible/playbooks/github/workflows/init
ansible/playbooks/github/workflows/init:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		cd $(HABITS)/lib/ansible && ansible-playbook playbooks/github/workflows/init.yaml --extra-vars="workspace=$(WORKSPACE) habits=$(HABITS)" ;\
	)

.PHONY: ansible/playbooks/github/workflows/remove
ansible/playbooks/github/workflows/remove:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		cd $(HABITS)/lib/ansible && ansible-playbook playbooks/github/workflows/remove.yaml --extra-vars="workspace=$(WORKSPACE) habits=$(HABITS)" ;\
	)

.PHONY: ansible/playbooks/ubuntu/update
ansible/playbooks/ubuntu/update:
	@( \
		. $(WORKSPACE)/.venv/bin/activate ;\
		cd $(HABITS)/lib/ansible && ansible-playbook playbooks/ubuntu/update.yaml --ask-become-pass ;\
	)
