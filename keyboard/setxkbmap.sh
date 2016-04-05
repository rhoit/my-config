#!/usr/bin/bash

# install
# install 755 setxkbmap.sh /usr/local/bin/setxkbmap

>&2 echo original_args: $*
args=$(echo "$*" | sed 's/us\|jp -option/dvorak/')
>&2 echo modified_args: ${args[*]}
/usr/bin/setxkbmap ${args[*]}
