#!/bin/sh

#. /etc/profile.d/afl-sh-profile

#aflize $1

#export CC=`echo $AFL_CC`
#export CXX=`echo $AFL_CXX`

cd ~/pkg
rm -rf *
apt-get -y build-dep $1
apt-get -y source $1
cd *
export CFLAGS="-fprofile-arcs -ftest-coverage"
export CXXFLAGS="-fprofile-arcs -ftest-coverage"
export LDFLAGS="-lgcov"
dpkg-buildpackage -uc -us
mv ~/pkg/*.deb ~/pkgs-coverage

exit 0
