#!/bin/sh

#. /etc/profile.d/afl-sh-profile

#aflize $1

#export CC=`echo $AFL_CC`
#export CXX=`echo $AFL_CXX`

mkdir -p ~/pkg ~/pkgs-coverage
cd ~/pkg
#rm -rf *
apt-get -y build-dep $1
apt-get -y source $1
cd $(find . -mindepth 1 -maxdepth 1 -type d -printf '%T@ %p\n' | sort -nr | head -n 1 | cut -d ' ' -f 2)

export CFLAGS="$(dpkg-buildflags --get CFLAGS) --coverage"
export DEB_CFLAGS_SET="$CFLAGS"
export CXXFLAGS="$(dpkg-buildflags --get CXXFLAGS) --coverage"
export DEB_CXXFLAGS_SET="$CXXFLAGS"
export LDFLAGS="$(dpkg-buildflags --get LDFLAGS) -lgcov"
export DEB_LDFLAGS_SET="$LDFLAGS"
touch /COVERAGE
dpkg-buildpackage -uc -us
mv ~/pkg/*.deb ~/pkgs-coverage

exit 0
