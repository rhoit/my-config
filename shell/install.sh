#!/bin/bash

list="zshrc bashrc shellrc shellrc.d"

for item in $list; do
    ( file ~/.$item | grep -v "symbolic" ) || continue
    echo $item starting..
    if [[ -e ~/.$item ]]; then
	    name="$item$(date +%s).bak"
	    mv ~/.$item ~/$name
	    echo "Old config has been renamed as $name"
    fi
    ln -s $PWD/$item ~/.$item
done

if [[ ! -e /tmp/git-prompt.sh && -e /usr/share/git/git-prompt.sh ]]; then
    echo "Try running configure again"
else
    cp /tmp/git-prompt.sh /opt/
    chmod +x /opt/git-prompt.sh
fi

PKG_REQ=(cowsay fortune)
which apt-get && { which ${PKG_REQ[@]} || apt-get install ${PKG_REQ[@]} }
which pacman && { which ${PKG_REQ[@]} || pacman -S ${PKG_REQ[@]} }
