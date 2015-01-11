#!/bin/bash

if [[ "$1" == "" ]]; then
    COMMAND="ln -s"
else
    COMMAND="cp"
fi

list="bashrc shellrc shellrc.d zshrc"

for item in $list; do
    ( file ~/.$item | grep -v "symbolic" ) || continue
    echo $item starting..
    if [[ -e ~/.$item ]]; then
	    name="$item$(date +%s).bak"
	    mv ~/.$item ~/$name
	    echo "Old config has been renamed as $name"
    fi
    $COMMAND $PWD/$item ~/.$item
done
