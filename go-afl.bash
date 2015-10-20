#!/bin/bash

for p in $(cat packages)
do
  aflize $p
done
