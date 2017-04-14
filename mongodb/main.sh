#!/usr/bin/env bash

## without npm

git clone --depth=1 https://github.com/TylerBrock/mongo-hacker /tmp/mongo-hacker
cd /tmp/mongo-hacker
sed -i 's/ln -sf/cp/' /tmp/mongo-hacker/Makefile
make install

## with npm
# pacman -S npm
# npm -g install mongo-hacker
# cd /usr/lib/node_modules/mongo-hacker/
# make install
