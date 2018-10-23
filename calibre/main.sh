#!/usr/bin/env bash

set -v

# stop fucking calibre timer
systemctl stop calibre-upgrade.timer
systemctl disable calibre-upgrade.timer
