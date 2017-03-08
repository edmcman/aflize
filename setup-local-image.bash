#!/bin/bash
set -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PKG="${1?No package specified}"
VOLDIR="$DIR/$PKG-covdata"
shift
EXTRAPKGS="$@"

# Pull -image if possible
if docker pull eschwartz/covize:$PKG
then
    docker tag -f eschwartz/covize:$PKG $PKG-image
else
    # If not, build it
    "$DIR/build-image.bash" $PKG $EXTRAPKGS
fi


# OK, the image is there.  Now we need to extract the covdata files.
if [ ! -d "$VOLDIR" ]
then
    mkdir "$VOLDIR"
    docker run --log-driver=none --rm $PKG-image tar -c -C /root/pkg . | tar -x -C "$VOLDIR"
fi
