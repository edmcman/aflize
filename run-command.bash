#!/bin/bash
set -ex

PKG="${1?}"
shift
PKGVOLDIR="$(pwd)/pkg"
FILE="${1?}"
shift
CMD="$@"

# copy FILE to docker container
test -f "$FILE"
NEWFILE="$PKGVOLDIR/$(basename $FILE)"
NEWDOCKFILE="/root/pkg/$(basename $FILE)"
cp "$FILE" "$NEWFILE"

docker run -it --rm=true -v $PKGVOLDIR:/root/pkg $PKG-image bash -i -c "${CMD//@@/$NEWDOCKFILE}"
