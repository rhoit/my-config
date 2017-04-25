#!/bin/bash

list="bashrc bashrc.d bash_profile shellrc shellrc.d zshrc inputrc"
# TODO zsh_profile -> bash_profile

for item in $list; do
    if [[ -e ~/.$item ]]; then
        name="$item$(date +%s).bak"
        mv ~/.$item ~/$name
        echo "Old config has been renamed as $name"
    fi
    ln --force -s $PWD/$item ~/.$item
    echo installed ~/.$item
done
