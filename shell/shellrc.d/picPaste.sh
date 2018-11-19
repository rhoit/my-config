#!/bin/bash

function picpaste {
	link='http://www.picpaste.com/upload.php'
	opts=( -F storetime=1 -F addprivacy=1 -F rules=yes )
	curl -sA firefox "${opts[@]}" -F upload=@"$1" "$link" \
		| sed -n '/Picture URL/{n;s/.*">//;s/<.*//p}'
}

function picpaste-screen {
    eog $(ls -t ~/*.png | head -1)
    picpaste $(ls -t ~/*.png | head -1)
}
