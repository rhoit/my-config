#!/usr/bin/bash

# Based on
## https://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/

pacman --noconfirm --needed --sync systemd systemd-sysvcompat
rm -f /etc/systemd/system/*.wants/*
(
    cd /lib/systemd/system/sysinit.target.wants/;
    for i in *; do
        [ $i == systemd-tmpfiles-setup.service ] && continue
        rm -f $i
    done
)

rm -f /lib/systemd/system/basic.target.wants/*
rm -f /lib/systemd/system/local-fs.target.wants/*
rm -f /lib/systemd/system/multi-user.target.wants/*
rm -f /lib/systemd/system/sockets.target.wants/*initctl*
rm -f /lib/systemd/system/sockets.target.wants/*udev*


# enable multi-user login
SERVICE="/usr/lib/systemd/system/systemd-user-sessions.service"
echo >> $SERVICE
echo "[Install]" >> $SERVICE
echo "WantedBy=default.target" >> $SERVICE
systemctl enable systemd-user-sessions.service


# install ssh
pacman --noconfirm --needed --sync openssh
systemctl enable sshd.service
mkdir -p /root/.ssh/
cp /tmp/id_rsa.pub /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
