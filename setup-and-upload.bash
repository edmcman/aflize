#!/bin/bash

set -x

for p in $@
do
    echo Building $p
    ./setup-image.bash $p
    docker tag $p-image eschwartz/covize:$p
    docker push eschwartz/covize:$p
done
