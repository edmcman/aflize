#!/bin/bash

cat <(echo deb file:///root/ pkgs-coverage/) /etc/apt/sources.list > /etc/apt/sources.list.new
mv /etc/apt/sources.list.new /etc/apt/sources.list

apt-get -y update
