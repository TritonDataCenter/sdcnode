#
# Copyright (c) 2012, Joyent, Inc. All rights reserved.
#
# SDC Node makefile.
#

include ./build/config.mk
include ./tools/mk/Makefile.defs

#
# Repo-specific targets
#
.PHONY: all
all: src node

.PHONY: dumpvar
dumpvar:
	@if [[ -z "$(VAR)" ]]; then \
		echo "error: set 'VAR' to dump a var"; \
		exit 1; \
	fi
	@echo "$(VAR) is '$($(VAR))'"


#include ./tools/mk/Makefile.deps
#include ./tools/mk/Makefile.targ
