#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright 2019 Joyent, Inc.
#

#
# sdcnode makefile
#

HOST_IMAGE=$(shell pfexec mdata-get sdc:image_uuid)

# Use HOST_IMAGE as the $(NAME) so that we can reuse eng.git's bits-upload
NAME=$(HOST_IMAGE)

ENGBLD_REQUIRE := $(shell git submodule update --init deps/eng)
include ./deps/eng/tools/mk/Makefile.defs

#
# Files
#
CLEAN_FILES += build/nodes bits
DISTCLEAN_FILES += build

ENGBLD_DEST_OUT_PATH ?= /public/releng/sdcnode

#
# Repo-specific targets
#
.PHONY: all
all: build/src nodes publish

build/src:
	git clone https://github.com/nodejs/node.git build/src

.PHONY: nodesrc
nodesrc: | build/src
	cd build/src && git checkout master \
		&& git fetch origin && git pull --rebase origin master

.PHONY: nodes
nodes: nodesrc
	./tools/build-all-nodes $(TOP)/build/nodes $(STAMP) "this.image=='$(HOST_IMAGE)'"

.PHONY: publish
publish: prepublish
	rm -rf $(TOP)/bits
	mkdir -p $(TOP)/bits/sdcnode
	cp $(TOP)/build/nodes/*/sdcnode-*.tgz $(TOP)/bits/sdcnode

include ./deps/eng/tools/mk/Makefile.targ
