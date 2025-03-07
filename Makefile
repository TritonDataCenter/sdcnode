#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

#
# Copyright 2022 Joyent, Inc.
# Copyright 2025 MNX Cloud, Inc.
#

#
# sdcnode makefile
#

HOST_IMAGE=$(shell pfexec mdata-get sdc:image_uuid)

# Use HOST_IMAGE as the $(NAME) so that we can reuse eng.git's bits-upload
NAME=$(HOST_IMAGE)

ENGBLD_REQUIRE := $(shell git submodule update --init deps/eng)
include ./deps/eng/tools/mk/Makefile.defs

# 21.4.0 images moved the MIN_PLATFORM up, so override the default
# build values if necessary. We need a more elegant way to do this
# when we start using images later than 21.4.0, and this should
# probably be in the previously included Makefile.defs anyway.
ifeq ($(shell $(_AWK) '/^Image/ {print $$3}' < /etc/product),21.4.0)
BASE_IMAGE_UUID = a7199134-7e94-11ec-be67-db6f482136c2
BUILD_PLATFORM  = 20210826T002459Z
else
ifeq ($(shell $(_AWK) '/^Image/ {print $$3}' < /etc/product),24.4.1)
BASE_IMAGE_UUID = 41bd4100-eb86-409a-85b0-e649aadf6f62
BUILD_PLATFORM  = 20210826T002459Z
endif
endif

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
	cd build/src && git checkout main \
		&& git fetch origin && git pull --rebase origin main

.PHONY: nodes
nodes: nodesrc
	./tools/build-all-nodes $(TOP)/build/nodes $(STAMP) "this.image=='$(HOST_IMAGE)'"

.PHONY: publish
publish: prepublish
	rm -rf $(TOP)/bits/sdcnode
	mkdir -p $(TOP)/bits/sdcnode
	cp $(TOP)/build/nodes/*/sdcnode-*.tgz $(TOP)/bits/sdcnode

include ./deps/eng/tools/mk/Makefile.targ
