#!/bin/bash

list="zshrc bashrc shellrc shellrc.d"

for item in $list; do
    echo $item
    if [[ -e ~/.$item ]]; then
	name="$item$(date +%s).bak"
	mv ~/.$item ~/$name
	echo "Old config has been renamed as $name"
    fi
    ln -s $PWD/$item ~/.$item
done

cp tmp/git-prompt.sh /opt/
