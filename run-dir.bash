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


mkdir -p "$VOLDIR/lcov"

rm /tmp/cov "$VOLDIR/cov.map" || true
touch /tmp/cov
lcov -z --directory "$VOLDIR"

n=0

for testcase in $(find "$TESTCASEDIR/.afl_seeds" "$TESTCASEDIR/.mayhem_seeds" -type f  -printf '%p %T@\n' | sort -n -k2,2 | awk '{print $1}')
do
    #lcov -z --directory "$VOLDIR"
    timeout -k 60 60 $DIR/run-command.bash "$PKG" $testcase "$CMD" >&2
    lcov --capture --directory "$VOLDIR" | $DIR/parse-info.py | sort -u > /tmp/new
    timestamp=$(find "$testcase" -printf '%T@\n')
    comm -13 /tmp/cov /tmp/new | while read -r l
    do
        n=$((n+1))
	echo \"$testcase\",\"$l\",\"$n\",\"$timestamp\" >> "$VOLDIR/lcov/cov.map"
    done
    cat /tmp/cov /tmp/new | sort -u > /tmp/cov2
    mv /tmp/cov2 /tmp/cov
done

rm /tmp/cov

lcov --directory "$VOLDIR" --capture > /tmp/cov
$DIR/lcov/bin/genhtml -o "$VOLDIR/lcov" /tmp/cov
