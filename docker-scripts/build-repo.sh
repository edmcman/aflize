#!/bin/sh

cd /root
dpkg-scanpackages pkgs-coverage > pkgs-coverage/Packages.gz
