#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PKG="${1?No package specified}"
shift
VOLDIR="$DIR/$PKG-covdata"
TESTCASEDIR="${1?Test case directory not specified}"
shift
CMD="$@"

if [ ! -d "$VOLDIR" ]
then
    echo "Settuping up coverage enabled build of $PKG"
    $DIR/setup-image.bash "$PKG"
fi

$DIR/afl-cov/afl-cov -v -d "$TESTCASEDIR" -c "$VOLDIR" --coverage-cmd "$DIR/run-command.bash $PKG AFL_FILE $CMD" --disable-gcov-check true

