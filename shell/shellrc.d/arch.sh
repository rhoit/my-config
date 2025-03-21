#!/bin/bash

#
## application related to archlinux

alias pm='pacman'
alias yaourt="echo 'use yay if you can or \yaourt to escape'"

function arch-pkgctl-help {
    echo "$1 is depreciated"
    echo "    pkgctl repo clone <package-name>"
    echo "    make sure to add the key to https://gitlab.archlinux.org"
}

alias abs='arch-pkgctl-help abs'
alias asp='arch-pkgctl-help asp'


function arch-yaourt-from-aur-makepkg {
    set -v
    sudo pacman --needed -Sy binutils pkg-config pacman fakeroot gcc yajl make
    cd /tmp
    curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz -o package-query.tar.gz
    tar xzf package-query.tar.gz
    cd /tmp/package-query
    makepkg
    sudo pacman -U package-query*pkg.tar.*

    cd /tmp
    curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz -o yaourt.tar.gz
    tar xzf yaourt.tar.gz
    cd /tmp/yaourt
    makepkg
    sudo pacman -U yaourt*pkg.tar.*
    set +v
}


function arch-paru-from-aur-makepkg {
    set -v
    sudo pacman --needed -Sy fakeroot git pacman debugedit
    cd /tmp
    curl --location https://aur.archlinux.org/cgit/aur.git/snapshot/paru-bin.tar.gz -o paru-bin.tar.gz
    tar xzf paru-bin.tar.gz
    cd /tmp/paru-bin
    makepkg --install
    set +v
}


function arch-outsource-pkg-download {
    (( $# == 0 )) && {
        echo "Usage:"
        echo "  $ arch-outsource-pkg-download user@ip /path/to/download/folder/"
        return
    }
    pacman -Sup | grep http > /tmp/pkglst
    scp /tmp/pkglst $1:$2
    ssh $1 tmux send-keys "mkdir\ \-p\ $2/pkg/" Enter
    ssh $1 tmux send-keys "cd\ $2/pkg" Enter
    ssh $1 tmux send-keys 'while\ read\ i\;\ do' Enter
    ssh $1 tmux send-keys 'wget\ \-c\ \$i' Enter
    ssh $1 tmux send-keys 'done\< ../pkglst' Enter
}


function arch-rsync-pkg-cache {
    (( $# == 0 )) && {
        echo "Usage:"
        echo "  $ arch-rsync-pkg-cache user@ip [/path/to/cache/folder/] [/path/to/remote/cache/folder]"
        return
    }

    pacman -Sup | grep http | xargs -n1 basename  > /tmp/pkglst
    wc -l /tmp/pkglst
    sudo rsync -r --append --progress --files-from=/tmp/pkglst $1:${2:=/var/cache/pacman/pkg} ${3:=/var/cache/pacman/pkg}
}


function arch-build-iso {
    # first argument take old archlive directory
    ## eg.
    # $ build-arch-iso /explicitly/give/path/to/build

    >/dev/null pacman -Qs archiso || {
        >&2 echo -e "\x1b[1marchiso\x1b[m not installed"
        >&2 echo -e "    # pacman -S archiso"
        return
    }

    ARCHLIVE=${1:-$(mktemp -d /tmp/archlive-XXXXX)}
    echo "$ARCHLIVE"
    mkdir -p "$ARCHLIVE/out"

    ## https://wiki.archlinux.org/index.php/archiso
    cp -r /usr/share/archiso/configs/baseline/* "$ARCHLIVE"
    cd "$ARCHLIVE" && sudo ./build.sh -v
}


function arch-build-docker-image {
    >&2 echo "before building update the system"
    >&2 echo "   # pacman -Sy"
    systemctl is-active docker --quiet || {
        >&2 echo "docker is not running"
        >&2 echo "    # systemctl start docker"
        return
    }
    cd ~/Documents/my-config/docker/
    ROOTFS="/tmp/docker-archlinux"
    sudo ./mkimage-arch.sh $ROOTFS
    sudo tar --numeric-owner --xattrs --acls --exclude-from=exclude -C $ROOTFS -c . |\
        docker import -c 'CMD ["/usr/bin/bash"]' -c 'ENV LANG=en_US.UTF-8' - rhoit/arch
    docker run --rm -t rhoit/arch pacman --version
    echo "$ docker push rhoit/arch"
}


function arch-mirrorlist-update-with-reflector {
    sudo pacman --needed -Sy reflector
    cd /etc/pacman.d/
    [ -f mirrorlist.pacnew ] || {
        echo '"mirrorlist.pacnew" not found'
        return
    }
    sudo mv mirrorlist mirrorlist.bak
    sudo cp mirrorlist.pacnew mirrorlist
    sudo cp mirrorlist mirrorlist.raw
    sudo reflector --verbose -l 25 -p http --sort rate --save /etc/pacman.d/mirrorlist && {
        sudo rm mirrorlist.pacnew
    }
    cd -
}
