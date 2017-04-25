#!/bin/bash

if [[ "$1" == "" ]]; then
    COMMAND="cp"
else
    COMMAND="ln -s"
fi

list="bashrc bashrc.d bash_profile shellrc shellrc.d zshrc"
# TODO zsh_profile -> bash_profile

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
