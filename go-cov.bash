#!/bin/bash

for p in $(cat packages)
do
  ./build-coverage-pkg.sh $p
done
