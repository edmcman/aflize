#!/bin/bash
set -ex

PKG="${1?}"
PKGVOLDIR="$(pwd)/pkg"

docker rm -f $PKG-temp || true
docker run -it --name $PKG-temp -v $PKGVOLDIR:/root/pkg covize bash -i -c './build-and-install-coverage-pkg.sh flasm'
docker commit $PKG-temp $PKG-image
