#!/bin/sh

set -e

PKG="$1"
shift
EXTRAPKGS="$@"

./build-coverage-pkg.sh "$PKG"
./build-repo.sh
./add-repo.bash
apt-get --allow-unauthenticated -y install $PKG $EXTRAPKGS
