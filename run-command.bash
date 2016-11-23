#!/bin/bash
set -ex

PKG="${1?}"
shift
VOLDIR="$(pwd)/$PKG-covdata"
FILE="${1?}"
shift
CMD="$@"

# copy FILE to docker container
test -f "$FILE"
NEWFILE="$VOLDIR/$(basename $FILE)"
NEWDOCKFILE="/root/pkg/$(basename $FILE)"
cp "$FILE" "$NEWFILE"

docker run -it --rm=true -v $VOLDIR:/root/pkg $PKG-image bash -i -c "${CMD//@@/$NEWDOCKFILE}"
