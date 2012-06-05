#
# Copyright (c) 2012, Joyent, Inc. All rights reserved.
#
# SDC Node makefile.
#

include ./tools/mk/Makefile.defs


include ./build/config.mk
NODE_COMMITISH ?= $(error config.mk does not define NODE_COMMITISH)
NODE_CONFIG_FLAGS ?= $(error config.mk does not define NODE_CONFIG_FLAGS)

#
# Variables
#
PKG_FILE=sdcnode-$(NODE_COMMITISH)-$(STAMP).tgz
CLEAN_FILES += build/node $(PKG_FILE)
DISTCLEAN_FILES += build

#
# Repo-specific targets
#
.PHONY: all
all: build/src build/node

build/src:
	git clone git://github.com/joyent/node.git build/src
	git checkout $(NODE_COMMITISH)

build/node:
	cd build/src \
		&& ./configure $(NODE_CONFIG_FLAGS) --prefix=$(TOP)/build/node \
		&& $(MAKE) \
		&& $(MAKE) install

.PHONY: pkg
pkg:
	cd build && $(TAR) czf $(PKG_FILE)


# The "publish" target requires that "BITS_DIR" be defined.
# Used by Mountain Gorilla.
.PHONY: publish
publish: $(BITS_DIR)
	@if [[ -z "$(BITS_DIR)" ]]; then \
		echo "error: 'BITS_DIR' must be set for 'publish' target"; \
		exit 1; \
	fi
	mkdir -p $(BITS_DIR)/sdcnode
	cp $(PKG_FILE) $(BITS_DIR)/sdcnode

.PHONY: dumpvar
dumpvar:
	@if [[ -z "$(VAR)" ]]; then \
		echo "error: set 'VAR' to dump a var"; \
		exit 1; \
	fi
	@echo "$(VAR) is '$($(VAR))'"


include ./tools/mk/Makefile.deps
include ./tools/mk/Makefile.targ
