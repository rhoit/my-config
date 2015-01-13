#!/bin/bash

rm -f installed
while read item; do
    echo "~/.$item" >> installed
    if [[ -e ~/.$item ]]; then
	    name="$item$(date +%s).bak"
	    mv ~/.$item ~/$name
	    echo "Old config has been renamed as $name"
    fi
    ln -s $PWD/$item ~/.$item
done < conf
