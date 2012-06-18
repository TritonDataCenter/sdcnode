#
# Copyright (c) 2012, Joyent, Inc. All rights reserved.
#
# SDC Node makefile.
#

include ./tools/mk/Makefile.defs


#
# Files
#
CLEAN_FILES += build/nodes bits
DISTCLEAN_FILES += build
DOC_FILES += index.restdown

ifeq ($(UPLOAD_LOCATION),)
	UPLOAD_LOCATION=stuff@stuff.joyent.us:builds
endif



#
# Repo-specific targets
#
.PHONY: all
all: build/src nodes bits

build/src:
	git clone git://github.com/joyent/node.git build/src

.PHONY: nodes
nodes: build/src
	./tools/build-all-nodes $(TOP)/build/nodes $(STAMP)

.PHONY: bits
bits:
	rm -rf $(TOP)/bits
	mkdir -p $(TOP)/bits/sdcnode
	cp $(TOP)/build/nodes/*/sdcnode-*.tgz $(TOP)/bits/sdcnode

# The "publish" target requires that "BITS_DIR" be defined.
# Used by Mountain Gorilla.
.PHONY: publish
publish: bits $(BITS_DIR)
	@if [[ -z "$(BITS_DIR)" ]]; then \
		echo "error: 'BITS_DIR' must be set for 'publish' target"; \
		exit 1; \
	fi
	mkdir -p $(BITS_DIR)/sdcnode
	cp $(TOP)/bits/sdcnode/sdcnode-*.tgz $(BITS_DIR)/sdcnode

# Upload bits to stuff
.PHONY: upload
upload:
	./tools/upload-bits "$(BRANCH)" "" "$(TIMESTAMP)" $(UPLOAD_LOCATION)/sdcnode

.PHONY: dumpvar
dumpvar:
	@if [[ -z "$(VAR)" ]]; then \
		echo "error: set 'VAR' to dump a var"; \
		exit 1; \
	fi
	@echo "$(VAR) is '$($(VAR))'"


include ./tools/mk/Makefile.deps
include ./tools/mk/Makefile.targ
