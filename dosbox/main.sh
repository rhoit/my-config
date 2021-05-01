#!/bin/bash

PATH_conf="${HOME}/.dosbox"
mkdir -p "${PATH_conf}"
ln -s "$PWD/config.ini" "${PATH_conf}/dosbox-0.74-3.conf"
