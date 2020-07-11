#!/usr/bin/bash

# based on
## official : https://github.com/archlinux/archlinux-docker
## docker: https://github.com/docker/docker/blob/master/contrib/mkimage-arch.sh
## blog: http://ebalaskas.gr/wiki/archlinux/installation_for_docker

set -e
set -u
# set -v # for debugging

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

# bootstrap
mkdir -pv "${ROOTFS}/var/lib/pacman/sync"
mkdir -pv "${ROOTFS}/etc/pacman.d"
cp /var/lib/pacman/sync/{community,core,extra}.db "${ROOTFS}/var/lib/pacman/sync"
cp /etc/pacman.d/mirrorlist "${ROOTFS}/etc/pacman.d/mirrorlist"

chmod 755 $ROOTFS

# required packages
PKG_REQUIRED=(
    grep
    mg
    pacman
)

# packages to ignore
PKG_IGNORE=(
    dhcpcd
    diffutils
    inetutils
    jfsutils
    linux
    lvm2
    man-db
    man-pages
    mdadm
    nano
    netctl
    openresolv
    pcmciautils
    reiserfsprogs
    s-nail
    sysfsutils
    usbutils
    vi
    which
    xfsprogs
)
IFS=','
PKG_IGNORE="${PKG_IGNORE[*]}"
unset IFS

PKG_REMOVE=(
    base
    cryptsetup
    device-mapper
    file
    gettext
    gzip
    iproute2
    iputils
    linux
    pciutils
    psmisc
    tar
)

# man pacman.conf
cat > /tmp/pm.conf <<EOF
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

[options]
NoExtract = usr/share/doc/*
NoExtract = usr/share/gtk-doc/*
NoExtract = usr/share/help/*
NoExtract = usr/share/i18n/*
NoExtract = usr/share/info/*
NoExtract = usr/share/licenses/*
NoExtract = usr/share/locale/*
NoExtract = usr/share/man/*
NoExtract = usr/share/vim/*
NoExtract = usr/share/zoneinfo/*
NoExtract = usr/share/common-lisp/*
NoExtract = usr/share/fish/*
NoExtract = usr/share/gdb/*
NoExtract = usr/share/vala/*
NoExtract = usr/share/zsh/*
NoExtract = usr/share/zoneinfo-leaps/*
EOF


env -i pacstrap -C /tmp/pm.conf -cdGM $ROOTFS ${PKG_REQUIRED[*]} --ignore $PKG_IGNORE
# arch-chroot $ROOTFS /bin/sh -c "ln -s /usr/share/zoneinfo/UTC /etc/localtime"
# echo 'en_US.UTF-8 UTF-8' > $ROOTFS/etc/locale.gen
# arch-chroot $ROOTFS locale-gen

# cleaning up
arch-chroot $ROOTFS /bin/sh -c "pacman-key --init"
arch-chroot $ROOTFS /bin/sh -c "pacman-key --populate archlinux"
arch-chroot $ROOTFS /bin/sh -c "for pkg in ${PKG_REMOVE[*]}; do pacman -Qi \$pkg && pacman -Rs --noconfirm \$pkg; done"

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

echo "run to add to docker"
echo "tar --numeric-owner --xattrs --acls -C $ROOTFS -c . -f archlinux.tar"
