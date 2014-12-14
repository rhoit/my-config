#!/bin/bash

PKGFILE=(gmrun mg python tmux X xle)
INSTALL_LIST=(gmrunrc mg pythonrc tmux.conf xinitrc xlerc)

for ((i=${#PKGFILE}; i >= 0; i--)); do
    which ${PKGFILE[i]} || continue
    list+="${INSTALL_LIST[i]} "
done

for item in $list; do
    ( file ~/.$item | grep -v "symbolic" ) || continue
    which PKG
    echo $item starting..
    if [[ -e ~/.$item ]]; then
	    name="$item$(date +%s).bak"
	    mv ~/.$item ~/$name
	    echo "Old config has been renamed as $name"
    fi
    ln -s $PWD/$item ~/.$item
done
