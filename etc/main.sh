#!/usr/bin/bash

for FILE in "issue"; do
    if [[ -e "/etc/$FILE" ]]; then
        echo "skip: '/etc/$FILE' already exisits"
        continue
    fi
    echo "installing $FILE"
    cp "$FILE" /etc/
done
