#!/usr/bin/env bash

sed -i "
    /GRUB_TIMEOUT/s/[0-9]\+/0/;
    /GRUB_CMDLINE_LINUX_DEFAULT/s/quiet//
" /etc/default/grub
