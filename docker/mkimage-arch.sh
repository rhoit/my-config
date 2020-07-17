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
chmod 755 $ROOTFS
cp /var/lib/pacman/sync/{community,core,extra}.db "${ROOTFS}/var/lib/pacman/sync"
cp /etc/pacman.d/mirrorlist "${ROOTFS}/etc/pacman.d/mirrorlist"


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
NoExtract = !usr/share/i18n/locales/en_GB
NoExtract = !usr/share/i18n/locales/en_US
NoExtract = !usr/share/i18n/locales/i18n
NoExtract = !usr/share/i18n/locales/i18n_ctype
NoExtract = !usr/share/i18n/locales/iso14651_t1
NoExtract = !usr/share/i18n/locales/iso14651_t1_common
NoExtract = !usr/share/i18n/locales/translit_circle
NoExtract = !usr/share/i18n/locales/translit_cjk_compat
NoExtract = !usr/share/i18n/locales/translit_combining
NoExtract = !usr/share/i18n/locales/translit_compat
NoExtract = !usr/share/i18n/locales/translit_font
NoExtract = !usr/share/i18n/locales/translit_fraction
NoExtract = !usr/share/i18n/locales/translit_narrow
NoExtract = !usr/share/i18n/locales/translit_neutral
NoExtract = !usr/share/i18n/locales/translit_small
NoExtract = !usr/share/i18n/locales/translit_wide
NoExtract = etc/systemd/*
NoExtract = lib/systemd/*
NoExtract = usr/share/X11/locale/*
NoExtract = usr/share/common-lisp/*
NoExtract = usr/share/doc/*
NoExtract = usr/share/fish/*
NoExtract = usr/share/gdb/*
NoExtract = usr/share/help/*
NoExtract = usr/share/i18n/charmaps/* !usr/share/i18n/charmaps/UTF-8.gz
NoExtract = usr/share/i18n/locales/*
NoExtract = usr/share/info/*
NoExtract = usr/share/licenses/*
NoExtract = usr/share/locale/*
NoExtract = usr/share/man/*
NoExtract = usr/share/vala/*
NoExtract = usr/share/vim/*
NoExtract = usr/share/zoneinfo-leaps/*
NoExtract = usr/share/zoneinfo/*
NoExtract = usr/share/zsh/*
EOF

PKG_REQUIRED=(
    pacman
    gzip
    sed
)

PKG_REMOVE=(
)

env -i pacstrap -C /tmp/pm.conf -cdGM $ROOTFS ${PKG_REQUIRED[*]}
arch-chroot $ROOTFS /bin/sh -c "pacman-key --init"
arch-chroot $ROOTFS /bin/sh -c "pacman-key --populate archlinux"

# arch-chroot $ROOTFS /bin/sh -c "ln -s /usr/share/zoneinfo/UTC /etc/localtime"
echo 'en_US.UTF-8 UTF-8' > $ROOTFS/etc/locale.gen
arch-chroot $ROOTFS locale-gen

arch-chroot $ROOTFS /bin/sh -c "for pkg in ${PKG_REMOVE[*]}; do pacman -Qi \$pkg && pacman -Rs --noconfirm \$pkg; done"

echo "run to add to docker"
echo "tar --numeric-owner --xattrs --acls -C $ROOTFS -c . -f archlinux.tar"
