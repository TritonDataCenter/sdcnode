#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright (c) 2018, Joyent, Inc.
#

#
# sdcnode makefile
#

include ./tools/mk/Makefile.defs


#
# Files
#
CLEAN_FILES += build/nodes bits
DISTCLEAN_FILES += build

HOST_IMAGE=$(shell mdata-get sdc:image_uuid)


#
# Repo-specific targets
#
.PHONY: all
all: build/src nodes bits

build/src:
	git clone https://github.com/nodejs/node.git build/src

.PHONY: nodesrc
nodesrc: | build/src
	cd build/src && git checkout master \
		&& git fetch origin && git pull --rebase origin master

.PHONY: nodes
nodes: nodesrc
	./tools/build-all-nodes $(TOP)/build/nodes $(STAMP) "this.image=='$(HOST_IMAGE)'"

.PHONY: bits
bits:
	rm -rf $(TOP)/bits
	mkdir -p $(TOP)/bits/sdcnode
	cp $(TOP)/build/nodes/*/sdcnode-*.tgz $(TOP)/bits/sdcnode

# Upload bits to $UPLOAD_LOCATION/...
.PHONY: upload
upload:
	[[ -n "$(UPLOAD_LOCATION)" ]] || (echo "error: UPLOAD_LOCATION is not defined" >&2 ; exit 1)
	./tools/upload-bits "$(BRANCH)" "" "$(TIMESTAMP)" $(UPLOAD_LOCATION)/sdcnode/$(HOST_IMAGE)

.PHONY: dumpvar
dumpvar:
	@if [[ -z "$(VAR)" ]]; then \
		echo "error: set 'VAR' to dump a var"; \
		exit 1; \
	fi
	@echo "$(VAR) is '$($(VAR))'"


include ./tools/mk/Makefile.deps
include ./tools/mk/Makefile.targ
