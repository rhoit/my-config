#!/bin/bash

if [[ "$1" == "" ]]; then
    COMMAND="ln -s"
else
    COMMAND="cp"
fi

list="bashrc shellrc shellrc.d zshrc"

for item in $list; do
    [ -L ~/.$item ] || rm -f ~/.$item
    if [[ -e ~/.$item ]]; then
        name="$item$(date +%s).bak"
        mv ~/.$item ~/$name
        echo "Old config has been renamed as $name"
    fi
    $COMMAND $PWD/$item ~/.$item
done
