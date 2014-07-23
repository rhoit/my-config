#!/bin/bash
#https://wiki.archlinux.org/index.php/Polkit

# Not advisable to edit
# /usr/share/polkit-1/actions/org.freedesktop.udisks2.policy

# <action id="org.freedesktop.udisks2.filesystem-mount-system">

#/usr/share/polkit-1/rules.d
#/etc/polkit-1/rules.d

cp ./10-enable-mount.rules /etc/polkit-1/rules.d/10-enable-mount.rules
