#!/bin/bash
set -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PKG="${1?No package specified}"
VOLDIR="$DIR/$PKG-covdata"
shift
EXTRAPKGS="$@"

docker rm -f $PKG-temp || true
docker run -i --name $PKG-temp -v $VOLDIR:/root/pkg eschwartz/covize bash -i -c "./build-and-install-coverage-pkg.sh $PKG $EXTRAPKGS"
docker commit $PKG-temp $PKG-image
