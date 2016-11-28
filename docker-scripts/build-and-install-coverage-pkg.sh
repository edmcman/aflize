#!/bin/sh

PKG="$1"

./build-coverage-pkg.sh "$PKG"
./build-repo.sh
./add-repo.bash
apt-get --allow-unauthenticated install "$PKG"
