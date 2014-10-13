<!--
    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->

<!--
    Copyright (c) 2014, Joyent, Inc.
-->

# SDC Node

This repository is part of the SmartDataCenter (SDC) project. For
contribution guidelines, issues, and general documentation, visit the
[main SDC project](http://github.com/joyent/sdc).

SDC Node builds Node.js tarballs on SmartOS for [SDC services](https://github.com/joyent/sdc/blob/master/docs/glossary.md#service).
Having node and npm as a git submodule for every repo and re-building node/npm
for every build of each service is crazy. Hence, we need a distro. This is it.


## Development

Building is only supported on SmartOS. Builds of "sdcnode" only target
SmartOS.

To build all sdcnode distro configurations:

    git clone git@github.com:joyent/sdcnode.git
    make all

Before committing/pushing run `make prepush` and, if possible, get a code
review.


### Configuration

The configuration for builds is controlled by "nodeconfig.json". We are not
currently using builds that statically link in openssl, but here is how you
would do one:

    {
        "comment": "Statically links OpenSSL.",
        "version": "v0.7.10",
        "configure_flags": "--with-dtrace",
        "build_tag": "simple"
    },


## Build configurations

The authority is [nodeconfigs.json](blob/master/nodeconfigs.json).
Currently sdcnode only includes Node.js build configurations required by
core SmartDataCenter services.

| Build Tag | Description |
| --------- | ----------- |
| gz        | Intended for services running in the global zone. Currently this statically links in OpenSSL and zlib, but the intention is to dynamically link with platform libs. |
| zone      | Intended for services running in a zone. It dynamically links to pkgsrc's OpenSSL and zlib in /opt/local. |


## License

SDC Node is licensed under the
[Mozilla Public License version 2.0](http://mozilla.org/MPL/2.0/).
