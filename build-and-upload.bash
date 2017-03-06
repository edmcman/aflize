#!/bin/bash

set -x

for p in $@
do
    echo Building $p
    ./build-image.bash $p
    docker tag -f $p-image eschwartz/covize:$p
    docker push eschwartz/covize:$p
done
