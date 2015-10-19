#!/bin/bash

for p in pdf2svg mplayer2 mp3gain imagemagick gif2png libjpeg-turbo-progs binutils
do
  ./build-coverage-pkg.sh $p
done
