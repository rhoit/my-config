#!/bin/bash

#
## application related to archlinux

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
