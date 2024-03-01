.PHONY: cobra/install
## Install cobra's cli
cobra/install:
	go install github.com/spf13/cobra-cli@latest

.PHONY: cobra/add
## Add a cobra command
cobra/add:
	$(call assert-set,COMMAND)
	cobra-cli add $(COMMAND)

.PHONY: cobra/del
## Delete a Cobra command
cobra/del:
	$(call assert-set,COMMAND)
	rm -f cmd/$(COMMAND).go
