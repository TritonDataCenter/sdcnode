<!--
    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, You can obtain one at http://mozilla.org/MPL/2.0/.
-->

<!--
    Copyright (c) 2014, Joyent, Inc.
-->

# SDC Node Builds

Repository: git@git.joyent.com:sdcnode.git
Browsing: <https://mo.joyent.com/sdcnode>
Who: Trent Mick
Docs: <https://mo.joyent.com/docs/sdcnode>
Tickets/bugs: <https://devhub.joyent.com/jira/browse/RELENG>
Jenkins: <https://jenkins.joyent.us/job/sdcnode/>

SmartOS builds of Node for SDC.


# Development

Building is only supported on smartos. Builds of "sdcnode" only target
smartos.

To build all sdcnode distro configurations:

    git clone git@git.joyent.com:sdcnode.git
    make all

To update the guidelines, edit "docs/index.restdown" and run `make docs`
to update "docs/index.html".

Before commiting/pushing run `make prepush` and, if possible, get a code
review.


# Dev Notes

The configuration for builds is controlled by "nodeconfig.json".  We are not
currently using builds that statically link in openssl (see TOOLS-130),
but here is how you would do one:

    {
        "comment": "Statically links OpenSSL.",
        "version": "v0.7.10",
        "configure_flags": "--with-dtrace",
        "build_tag": "simple"
    },


