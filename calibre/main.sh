#!/usr/bin/env bash

# stop fucking calibre timer
systemctl stop calibre-upgrade.timer
systemctl disable calibre-upgrade.timer
