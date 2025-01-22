This repository is part of the Triton Data Center project. See the [contribution
guidelines](https://github.com/TritonDataCenter/triton/blob/master/CONTRIBUTING.md)
and general documentation at the main
[Triton project](https://github.com/TritonDataCenter/triton) page.

# sdcnode

Custom SmartOS builds of Node.js for use by Triton and Manta components.

All Triton/Manta services should bundle their own node for independence (with
the exception of node.js code that ships with the platform and use the
platform's node build). These services need a node (and npm) build. They can
either build it themselves or get a pre-built one. Having node/npm as a git
submodule for every repo and re-building node/npm for every build of each
service is crazy. Hence, we need a distro. This is it.

## Building

To build the sdcnodes for the matching image as the building machine:

    make all

## CI

Typically sdcnode builds for all targetted images are built for each commit via
the Triton Data Center Jenkins instance. See
<https://jenkins.tritondatacenter.com/job/TritonDataCenter/job/sdcnode/>. They
are published to <https://download.tritondatacenter.com/pub/build/sdcnode/>.

## Build configurations

[nodeconfigs.json](./nodeconfigs.json) specifies all the flavours of node that
are built. There are configurations for a matrix of the following variables:

- node.js version

- origin image, e.g. [minimal-64-lts](https://docs.tritondatacenter.com/public-cloud/instances/infrastructure/images/smartos/minimal), which implies a pkgsrc generation and sometimes the `gcc` version used

- "build tag" for different build/configuration paramters:

    | Build Tag | Description |
    | --------- | ----------- |
    | gz        | Intended for services running in the global zone or those that cannot otherwise depend on any pkgsrc libs (which are not available in the global zone). |
    | zone      | Intended for services running in a zone. It dynamically links to some pkgsrc libs in "/opt/local". |
    | zone64    | Intended for node.js services that require a 64-bit build of node. |


The requirement is that the set of sdcnode configurations built cover the
usage by all current and maintained (for release-branches getting maintenance
work) Triton and Manta components.

Here are some commands to see a breakdown of current sdcnode configs:

    # by build_tag
    json -f nodeconfigs.json -a build_tag | sort | uniq -c | sort

    # by version
    json -f nodeconfigs.json -a version | sort | uniq -c | sort

    # by image
    json -f nodeconfigs.json -a image "// image" | sort | uniq -c | sort


## Determining sdcnode usage by Triton and Manta

Here is a *start* at commands to list current usage of sdcnode configs by
Triton and Manta components.

1. Setup `jr` per <https://github.com/TritonDataCenter/joyent-repos#jr>.

2. Get and update a clone of all top-level Triton/Manta release repos:

    ```
    mkdir release-repos
    cd release-repos
    jr clone -y -l release,triton
    jr clone -y -l release,manta
    jr up -c 5  # currently needed once to get submodules
    ```

    If you already have those clones, you just need to do this to update:

    ```
    cd release-repos
    jr up -c 5
    ```

3. List the used node.js versions:

    ```
    find . -name Makefile | grep -v deps/eng/Makefile \
        | xargs grep NODE_PREBUILT_VERSION \
        | awk -F '(:=|=|:)' '{print $1 " " $3}' \
        | awk '{printf("%-10s %s\n", $2, $1)}' | sort
    ```

Note: Just listing the *versions* used isn't the full story. It would be good
to list the full (version, image, build_tag) usage set so we could further
trim the built sdcnode configs.
