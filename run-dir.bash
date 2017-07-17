#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TEMP=`getopt -o d: --long dir: -- "$@"`
if [ $? != 0 ]
then
   exit 1
fi

eval set -- "$TEMP"

DIRS=""

while true
do
    case "$1" in
        -d|--dir)
            TDIR="$2"
            shift 2
            DIRS="$DIRS $TDIR"
            ;;
        --) shift; break;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

if [ "$DIRS" = "" ]
then
    echo "You must specify at least one directory"
    exit 1
fi

PKG="${1?No package specified}"
shift
VOLDIR="$DIR/$PKG-covdata"
CMD="$@"

if [ ! -d "$VOLDIR" ]
then
    echo "Settuping up coverage enabled build of $PKG"
    $DIR/setup-local-image.bash "$PKG"
fi


mkdir -p "$VOLDIR/lcov"

rm /tmp/cov "$VOLDIR/cov.map" || true
touch /tmp/cov
$DIR/lcov/bin/lcov -z --directory "$VOLDIR"

n=0

for testcase in $(find $DIRS -type f  -printf '%p %T@\n' | sort -n -k2,2 | awk '{print $1}')
do
    #lcov -z --directory "$VOLDIR"
    timeout -k 60 60 $DIR/run-command.bash "$PKG" $testcase "$CMD" >&2
    $DIR/lcov/bin/lcov --ignore-errors source --capture --directory "$VOLDIR" | $DIR/parse-info.py | sort -u > /tmp/new
    timestamp=$(find "$testcase" -printf '%T@\n')
    while read -r l
    do
        n=$((n+1))
	echo \"$testcase\",\"$l\",\"$n\",\"$timestamp\" >> "$VOLDIR/lcov/cov.map"
    done < <(comm -13 /tmp/cov /tmp/new)
    cat /tmp/cov /tmp/new | sort -u > /tmp/cov2
    mv /tmp/cov2 /tmp/cov
done

rm /tmp/cov

$DIR/lcov/bin/lcov --directory "$VOLDIR" --capture > /tmp/cov
$DIR/lcov/bin/genhtml --ignore-errors source -o "$VOLDIR/lcov" /tmp/cov
