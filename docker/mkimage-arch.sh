#!/usr/bin/env bash

# based on
## docker: https://github.com/docker/docker/blob/master/contrib/mkimage-arch.sh
## blog:  http://ebalaskas.gr/wiki/archlinux/installation_for_docker

set -e
set -u

hash pacstrap &>/dev/null || {
	echo "Could not find pacstrap. Run pacman -S arch-install-scripts"
	exit 1
}

hash expect &>/dev/null || {
	echo "Could not find expect. Run pacman -S expect"
	exit 1
}


ROOTFS=${1:-$(mktemp -u /tmp/docker-archlinux-XXXXX)}

if [[ -d $ROOTFS ]]; then
    echo -n "Do you wanna continue old build? [y/n] "
    read reply
    if [[ $reply == "y" || $reply == "Y" || $reply == "" ]]; then
        echo "continue with $ROOTFS"
        reply="y"
    else
        rm -rf $ROOTFS
    fi
fi

umask 022 # reset umask to default
export LANG="C.UTF-8"
export LC_ALL="C"

# shortcut
mkdir -pv $ROOTFS/var/lib/pacman/sync
cp /var/lib/pacman/sync/{community,core,extra}.db $ROOTFS/var/lib/pacman/sync

chmod 755 $ROOTFS

# required packages
PKG_REQUIRED=(
    base
	haveged
	pacman
	pacman-mirrorlist
    mg
)

# packages to ignore
PKG_IGNORE=(
    # systemd-sysvcompat # for installing systemd
    dhcpcd
    diffutils
    file
    gettext
    inetutils
    iproute2
    iputils
    jfsutils
    linux
    lvm2
    man-db
    man-pages
    mdadm
    nano
    netctl
    openresolv
    pciutils
    pcmciautils
    psmisc
    reiserfsprogs
    s-nail
    sysfsutils
    tar
    usbutils
    vi
    which
    xfsprogs
)


cat > /tmp/pacman.conf <<EOF
[options]
HoldPkg      = pacman glibc
Architecture = auto
SigLevel     = Required DatabaseOptional
LocalFileSigLevel = Optional

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[community]
Include = /etc/pacman.d/mirrorlist
EOF

expect <<EOF
	set send_slow {1 .1}
	proc send {ignore arg} {
		sleep .1
		exp_send -s -- \$arg
	}
	set timeout 90

	spawn pacstrap -C /tmp/pacman.conf -c -d -G -i $ROOTFS $PKG_REQUIRED --ignore $PKG_IGNORE
	expect {
		-exact "anyway? \[Y/n\] " { send -- "n\r"; exp_continue }
		-exact "(default=all): " { send -- "\r"; exp_continue }
		-exact "installation? \[Y/n\]" { send -- "y\r"; exp_continue }
		-exact "delete it? \[Y/n\]" { send -- "y\r"; exp_continue }
	}
EOF

# if copied
# sed -i '0,/#.*Server/s/#//' $path_img/etc/pacman.d/mirrorlist
# sed -i 's/^SigLevel.*/SigLevel = Never/g' $path_img/etc/pacman.conf
PACMAN_MIRRORLIST='Server = https://mirrors.kernel.org/archlinux/$repo/os/$arch'
export PACMAN_MIRRORLIST
arch-chroot $ROOTFS /bin/sh -c 'echo $PACMAN_MIRRORLIST > /etc/pacman.d/mirrorlist'


# clean-up
arch-chroot $ROOTFS /bin/sh -c 'rm -r /usr/share/man/*'
arch-chroot $ROOTFS /bin/sh -c 'rm -r /usr/share/info/*'
arch-chroot $ROOTFS /bin/sh -c 'rm -r /usr/share/doc/*'
arch-chroot $ROOTFS /bin/sh -c 'rm -r /usr/share/zoneinfo/*'
arch-chroot $ROOTFS /bin/sh -c 'rm -r /usr/share/i18n/*'
arch-chroot $ROOTFS /bin/sh -c "haveged -w 1024; pacman-key --init; pkill haveged; pacman -Rs --noconfirm haveged; pacman-key --populate archlinux; pkill gpg-agent"
# arch-chroot $ROOTFS /bin/sh -c "ln -s /usr/share/zoneinfo/UTC /etc/localtime"
# echo 'en_US.UTF-8 UTF-8' > $ROOTFS/etc/locale.gen
# arch-chroot $ROOTFS locale-gen


## clean unneeded services
arch-chroot $ROOTFS /bin/sh -c 'for i in /lib/systemd/system/sysinit.target.wants/*; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done'
arch-chroot $ROOTFS /bin/sh -c 'rm -f /lib/systemd/system/multi-user.target.wants/*'
arch-chroot $ROOTFS /bin/sh -c 'rm -f /lib/systemd/system/graphical.target.wants/*'
arch-chroot $ROOTFS /bin/sh -c 'rm -f /etc/systemd/system/*.wants/*'
arch-chroot $ROOTFS /bin/sh -c 'rm -f /lib/systemd/system/local-fs.target.wants/*'
arch-chroot $ROOTFS /bin/sh -c 'rm -f /lib/systemd/system/sockets.target.wants/*udev*'
arch-chroot $ROOTFS /bin/sh -c 'rm -f /lib/systemd/system/sockets.target.wants/*initctl*'
arch-chroot $ROOTFS /bin/sh -c 'rm -f /lib/systemd/system/basic.target.wants/*'
arch-chroot $ROOTFS /bin/sh -c 'rm -f /lib/systemd/system/anaconda.target.wants/*'


# udev doesn't work in containers, rebuild /dev
DEV=$ROOTFS/dev
rm -rf $DEV
mkdir -p $DEV
mknod -m 666 $DEV/null c 1 3
mknod -m 666 $DEV/zero c 1 5
mknod -m 666 $DEV/random c 1 8
mknod -m 666 $DEV/urandom c 1 9
mkdir -m 755 $DEV/pts
mkdir -m 1777 $DEV/shm
mknod -m 666 $DEV/tty c 5 0
mknod -m 600 $DEV/console c 5 1
mknod -m 666 $DEV/tty0 c 4 0
mknod -m 666 $DEV/full c 1 7
mknod -m 600 $DEV/initctl p
mknod -m 666 $DEV/ptmx c 5 2
ln -sf /proc/self/fd $DEV/fd

tar --numeric-owner --xattrs --acls -C $ROOTFS -c . | docker import - local/arch
docker run --rm -t local/arch pacman --version
