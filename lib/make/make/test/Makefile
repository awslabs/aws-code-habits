# Ensures that a variable is defined and non-empty
define assert-set
	@$(if $($(1)),,$(error $(1) not defined in $(@)))
endef

# Ensures that a variable is undefined
define assert-unset
	@$(if $($1),$(error $(1) should not be defined in $(@)),)
endef

test/assert-set:
	$(call assert-set,PATH)
	@echo assert-set PASS

test/assert-unset:
	$(call assert-unset,PATH)
	@echo assert-unset PASS

test/assert: test/assert-set test/assert-unset
	@exit 0
