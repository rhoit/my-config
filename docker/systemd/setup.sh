#!/usr/bin/bash

# Based on
## https://developers.redhat.com/blog/2014/05/05/running-systemd-within-docker-container/

pacman --noconfirm --sync --refresh --sysupgrade # long form of -Syu
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
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
echo 'Banner /etc/ssh-banner' >> /etc/ssh/sshd_config
systemctl enable sshd.service
mkdir -m 700 -p /root/.ssh/
USER='root' PASS='toor'
echo "$USER:$PASS" | chpasswd

# show ip
cat > /etc/systemd/system/ipshow.service <<EOF
[Unit]
Description=show the continer IP
Requires=network-online.target

[Service]
Type=idle
ExecStartPre=cat /proc/1/cpuset
ExecStart=/usr/bin/tail -1 /etc/hosts

[Install]
WantedBy=default.target
EOF
systemctl enable ipshow.service
