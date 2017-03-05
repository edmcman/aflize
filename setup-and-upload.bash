#!/bin/bash

set -x

for p in $@
do
    echo Building $p
    ./setup-image.bash $p
    git tag $p-image eschwartz/$p-image
    git push eschwartz/$p-image
done
