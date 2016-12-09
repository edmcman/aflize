#!/bin/sh

mkdir -p ~/pkg ~/pkgs-coverage
cd ~/pkg

apt-get -y update
apt-get -y build-dep $1
apt-get -y source $1

cd $(find . -mindepth 1 -maxdepth 1 -type d -printf '%T@ %p\n' | sort -nr | head -n 1 | cut -d ' ' -f 2)

touch /COVERAGE
dpkg-buildpackage -uc -us
rm /COVERAGE
mv ~/pkg/*.deb ~/pkgs-coverage

exit 0
