#!/bin/sh

set -e

AVAHI_VERSION="0.6.31-4ubuntu4snap2"
LIBDAEMON0_VERSION="0.14-6"

get_arch() {
    arch=$1

    case $arch in
        amd64)
            plat_abi=$arch
        ;;
        arm)
            plat_abi=armhf
        ;;
        armhf)
            plat_abi=armhf
        ;;
        *)
            echo "bad platform"
            exit 1
        ;;
    esac

    echo $plat_abi
}

gobuild() {
    arch=$1
    echo Building for $arch

    plat_abi=$(get_arch $arch)

    mkdir -p "bin/$plat_abi"
    cd "bin/$plat_abi"
    GOARCH=$arch go build launchpad.net/webdm-mcast/cmd/metabin
    cd - > /dev/null
}

orig_pwd=$(pwd)

builddir=$(mktemp -d)
trap 'rm -rf "$builddir"' EXIT

cp -r pkg/. $builddir
cd $builddir

sed -i 's/\(architecture: \)UNKNOWN_ARCH/\1[amd64, armhf]/' \
    $builddir/meta/package.yaml

gobuild arm
gobuild amd64

cd "$orig_pwd"

snappy build $builddir
