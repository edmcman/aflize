#!/bin/bash
set -ex

PKG="${1?}"
VOLDIR="$(pwd)/$PKG-covdata"

docker rm -f $PKG-temp || true
docker run -i --name $PKG-temp -v $VOLDIR:/root/pkg covize bash -i -c './build-and-install-coverage-pkg.sh flasm'
docker commit $PKG-temp $PKG-image
