#!/bin/sh

PKG="$1"

./build-coverage-pkg.sh "$PKG"
./build-repo.sh
./add-repo.bash
apt --allow-unauthenticated install "$PKG"
