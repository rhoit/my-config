#!/bin/bash

while read item; do
    echo "~/.$item" >> installed.new
    if [[ -e ~/.$item ]]; then
	    name="$item$(date +%s).bak"
	    mv ~/.$item ~/$name
	    echo "Old config has been renamed as $name"
    fi
    ln -s $PWD/$item ~/.$item
done < conf

if [[ -e installed.new ]]; then
    rm -f installed
    mv installed.new installed
fi
