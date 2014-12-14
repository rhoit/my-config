#!/bin/bash

list="gmrunrc mg pythonrc tmux.conf xinitrc xlerc"

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
