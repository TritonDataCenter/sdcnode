# SDC Node Builds

Repository: <git@git.joyent.com:sdcnode.git>
Browsing: <https://mo.joyent.com/sdcnode>
Who: Trent Mick
Docs: <https://mo.joyent.com/docs/sdcnode>
Tickets/bugs: <https://devhub.joyent.com/jira/browse/RELENG>


# Overview

All SDC services should carry their own node with then for independence.
(The exception is those that are part of the platform: for which using
the platform node is fine.) These services need a node (and npm) build.
They can either build it themselves or get a pre-built one. Having node/npm
as a git submodule for every repo and re-building node/npm for every build of
each service is crazy. Hence, we need a distro. This is it.


# Development

Building is only supported on smartos. Builds of "sdcnode" only target
smartos.

To build an sdcnode distro:

    git clone git@git.joyent.com:sdcnode.git
    ./configure --node=COMMITISH [--node-configure='--with-foo' --build-tag=foo]
    make release

To update the guidelines, edit "docs/index.restdown" and run `make docs`
to update "docs/index.html".

Before commiting/pushing run `make prepush` and, if possible, get a code
review.


# Node Build Details

- only target SmartOS
- by default we link against openssl at /opt/local
- by default we configure '--with-dtrace'


# Releases

Build products are a tarball of node:

    # A typical v0.6 build with the pkgsrc gcc on smartos-1.6.3.
    sdcnode-v0.6.15-gcc4.6.2-20120604T235421Z.tgz

    # A custom config that statically links openssl, for example.
    sdcnode-v0.6.15-gcc4.6.2-openssl-20120604T235421Z.tgz

    # The "foo" here is the build tag: used to distinguish from
    # default configuration builds.
    sdcnode-v0.6.15-gcc4.6.2-foo-20120604T235421Z.tgz

TODO: Do we need to specify the install prefix? Don't think so. That is built
in to "build/node" and we make install to there. I guess node installs are
relocatable.

