#!/bin/bash

#
## application related to archlinux

function arch-outsource-pkg-download {
    REMOTE="${1}"; test -n "$REMOTE" || {
        echo "Usage:"
        echo "  $ $0 user@uri [/var/cache/pacman/pkg]"
        return
    }
    pacman pacman --sync --sysupgrade --print | grep http | tee /tmp/pkglst
    scp /tmp/pkglst "$REMOTE":"$2"
    ssh "$REMOTE" tmux send-keys "mkdir\ \-p\ $2/pkg/" Enter
    ssh "$REMOTE" tmux send-keys "cd\ $2/pkg" Enter
    ssh "$REMOTE" tmux send-keys 'while\ read\ i\;\ do' Enter
    ssh "$REMOTE" tmux send-keys 'wget\ \-c\ \$i' Enter
    ssh "$REMOTE" tmux send-keys 'done\< ../pkglst' Enter
}


function arch-rsync-pkg-cache {
    REMOTE="${1}"; test -n "$REMOTE" || {
        echo "Usage:"
        echo "  $ $0 user@uri [:/var/cache/pacman/pkg] [/var/cache/pacman/pkg]"
        return
    }
    PATH_src=${2:=/var/cache/pacman/pkg}
    PATH_dst=${3:=/var/cache/pacman/pkg}
    pacman --sync --sysupgrade --print | grep http | xargs -n1 basename | tee /tmp/pkglst
    sudo rsync --recursive --append --progress --files-from=/tmp/pkglst $REMOTE:$PATH_src $PATH_dst
}


function arch-build-iso {
    # first argument take old archlive directory
    ## eg.
    # $ build-arch-iso /explicitly/give/path/to/build

    >/dev/null pacman --query --search archiso || {
        >&2 echo -e "\x1b[1marchiso\x1b[m not installed"
        >&2 echo -e "    # pacman -S archiso"
        return
    }

    ARCHLIVE=${1:-$(mktemp --directory /tmp/archlive-XXXXX)}
    echo "$ARCHLIVE"
    mkdir --parents "$ARCHLIVE/out"

    ## https://wiki.archlinux.org/index.php/archiso
    cp --recursive /usr/share/archiso/configs/baseline/* "$ARCHLIVE"
    cd "$ARCHLIVE" && sudo ./build.sh -v
}


function arch-mirrorlist-update-with-reflector {
    sudo pacman --sync --refresh --needed reflector
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
