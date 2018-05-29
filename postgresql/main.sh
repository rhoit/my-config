#!/usr/bin/env bash

# Prevent disk writes when idle
## https://wiki.archlinux.org/index.php/PostgreSQL#Prevent_disk_writes_when_idle

# PostgreSQL periodically updates its internal "statistics" file. By
# default, this file is stored on disk, which prevents disks from
# spinning down on laptops and causes hard drive seek noise. It is
# simple and safe to relocate this file to a memory-only file system
# with the following configuration option:

# /var/lib/postgres/data/postgresql.conf
# stats_temp_directory = '/run/postgresql'

# Improve performance of small transactions for development
# synchronous_commit = off