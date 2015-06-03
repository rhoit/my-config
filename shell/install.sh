#!/bin/bash

if [[ "$1" == "" ]]; then
    COMMAND="ln -s"
else
    COMMAND="cp"
fi

list="bashrc bashrc.d bash_profile shellrc shellrc.d zshrc"

rm -f installed
for item in $list; do
    echo "~/.$item" >> installed
    if [[ -e ~/.$item ]]; then
        name="$item$(date +%s).bak"
        mv ~/.$item ~/$name
        echo "Old config has been renamed as $name"
    fi
    $COMMAND $PWD/$item ~/.$item
done
