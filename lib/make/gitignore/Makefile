# default gitignore template rules
GITIGNORE?=macos,windows,linux,visualstudiocode,python,node

# add local persistent gitignore additions here
GITIGNORE_LOCAL_FILE?=.gitignore_local

.PHONY: gitignore/install
## Install gitignore
gitignore/install:
	@sudo cp $(HABITS)/lib/scripts/gitignore.sh /usr/local/bin/gitignore
	@sudo chmod +x /usr/local/bin/gitignore

.PHONY: gitignore/list
## List all gitignore templates
gitignore/list:
	@gitignore list

.PHONY: gitignore/init
## Create .gitignore file
gitignore/init:
	@gitignore $(GITIGNORE) > .gitignore
	if [ -f $(GITIGNORE_LOCAL_FILE) ]; then
		cat $(GITIGNORE_LOCAL_FILE) >> .gitignore
	fi
