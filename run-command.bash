#!/bin/bash
set -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PKG="${1?}"
shift
VOLDIR="$DIR/$PKG-covdata"
FILE="${1?}"
shift
CMD="$@"

# copy FILE to docker container
test -f "$FILE"
NEWDOCKFILE="/tmp/$(basename $FILE)"

cat "$FILE" | docker run --log-driver=none -i --rm=true -v $VOLDIR:/root/pkg $PKG-image bash -i -c "cat >$NEWDOCKFILE && ${CMD//@@/$NEWDOCKFILE}"
