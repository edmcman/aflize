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
NEWDOCKFILE="/tmp/$(basename $FILE)"

cat "$FILE" | docker run -i --rm=true -v $VOLDIR:/root/pkg $PKG-image bash -i -c "cat >$NEWDOCKFILE && ${CMD//\$SEEDFILE/$NEWDOCKFILE}"
