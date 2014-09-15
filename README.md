<!--
    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->

<!--
    Copyright (c) 2014, Joyent, Inc.
-->

# sdcnode

This repository is part of the Joyent SmartDataCenter project (SDC).  For
contribution guidelines, issues, and general documentation, visit the main
[SDC](http://github.com/joyent/sdc) project page.

SmartOS builds of Node for SDC.

All SmartDataCenter services should carry their own node with then for
independence. (The exception is those that are part of the platform: for
which using the platform node is fine.) These services need a node (and npm)
build. They can either build it themselves or get a pre-built one. Having
node/npm as a git submodule for every repo and re-building node/npm for every
build of each service is crazy. Hence, we need a distro. This is it.


# Development

Building is only supported on smartos. Builds of "sdcnode" only target
smartos.

To build all sdcnode distro configurations:

    git clone git@github.com:joyent/sdcnode.git
    make all

Before commiting/pushing run `make prepush` and, if possible, get a code
review.


# Dev Notes

The configuration for builds is controlled by "nodeconfig.json".  We are not
currently using builds that statically link in openssl, but here is how you
would do one:

    {
        "comment": "Statically links OpenSSL.",
        "version": "v0.7.10",
        "configure_flags": "--with-dtrace",
        "build_tag": "simple"
    },


# Build configurations

The authority is <https://github.com/joyent/sdcnode/blob/master/nodeconfigs.json>.
Currently sdcnode only includes node build configurations required by
core SmartDataCenter services.

||**Build Tag**||**Description**||
||gz||Intended for services running in the global zone. Currently this statically links in OpenSSL and zlib, but the intention is to dynamically link with platform libs.||
||zone||Intended for services running in a zone. It dynamically links to pkgsrc's OpenSSL and zlib in /opt/local.||
