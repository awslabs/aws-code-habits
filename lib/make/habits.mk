.PHONY: habits/install
## Install Habits dependencies
habits/install: \
	gitignore/install \
	python/pip/install \
	ansible/install \
	pre-commit/install

.PHONY: habits/init
## Initialize gitignore, documentation, pre-commit, github workflows, issues and pull-request
habits/init: \
	gitignore/init \
	doc/init \
	pre-commit/init \
	github/actions/init \
	github/issues/init \
	github/pull-request/init \
	github/workflows/init

.PHONY: habits/update
## Update Habits
habits/update:
	@git submodule update --remote --merge

.PHONY: habits/remove
## Uninstall Habits
habits/remove: \
	ansible/playbooks/aws/config/remove \
	ansible/playbooks/doc/remove \
	pre-commit/remove \
	ansible/playbooks/github/actions/remove \
	ansible/playbooks/github/issues/remove \
	ansible/playbooks/github/pull-request/remove \
	ansible/playbooks/github/workflows/remove \
	ansible/playbooks/habits/remove \
	habits/submodule/remove \
	python/virtualenv/remove

.PHONY: habits/submodule/remove
habits/submodule/remove:
	-git submodule deinit --force habits
	-git rm --cached habits/
	@rm -rf habits

.PHONY: habits/check
## Performs checks
habits/check:
ifeq ("$(wildcard doc)", "")
	@echo "Directory doc/ not found. To fix, run: make doc/init" && exit 1
endif
ifeq ("$(wildcard doc/habits.yaml)", "")
	@echo "File doc/habits.yaml not found. To fix, run: make doc/init" && exit 1
endif
ifeq ("$(wildcard CHANGELOG.md)", "")
	@echo "File CHANGELOG.md not found. To fix, run: make doc/init" && exit 1
endif
ifeq ("$(wildcard CODE_OF_CONDUCT.md)", "")
	@echo "File CODE_OF_CONDUCT.md not found. To fix, run: make doc/init" && exit 1
endif
ifeq ("$(wildcard CONTRIBUTING.md)", "")
	@echo "File CONTRIBUTING.md not found. To fix, run: make doc/init" && exit 1
endif
ifeq ("$(wildcard SECURITY.md)", "")
	@echo "File SECURITY.md not found. To fix, run: make doc/init" && exit 1
endif
ifeq ("$(wildcard README.md)", "")
	@echo "File README.md not found. To fix, run: make doc/build" && exit 1
endif
ifeq ("$(wildcard .pre-commit-config.yaml)", "")
	@echo "File .pre-commit-config.yaml not found. To fix, run: make pre-commit/init" && exit 1
endif
ifeq ("$(wildcard .gitignore)", "")
	@echo "File .gitignore not found. To fix, run: make gitignore/install gitignore/init" && exit 1
endif
ifeq ("$(wildcard .github/actions)", "")
	@echo "Directory .github/actions not found. To fix, run: make github/actions/init" && exit 1
endif
ifeq ("$(wildcard .github/workflows)", "")
	@echo "Directory .github/workflows not found. To fix, run: make github/workflows/init" && exit 1
endif
ifeq ("$(wildcard .github/ISSUE_TEMPLATE)", "")
	@echo "Directory .github/ISSUE_TEMPLATE not found. To fix, run: make github/issues/init" && exit 1
endif
ifeq ("$(wildcard .github/pull_request_template.md)", "")
	@echo "File .github/pull_request_template.md not found. To fix, run: make github/pull-request/init" && exit 1
endif
	@echo "perform habits checks....................................................Passed"
