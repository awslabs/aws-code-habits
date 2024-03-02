.PHONY: prettier/install
prettier/install:
	npm install -g prettier

.PHONY: prettier/run
prettier/run:
	prettier --write .

.PHONY: prettier/check
prettier/check:
	prettier --check .

.PHONY: prettier/version
prettier/version:
	prettier --version
