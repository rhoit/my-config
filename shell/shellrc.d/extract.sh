#!/bin/bash

extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.7z)       7z x $1       ;;
            *.Z)        uncompress $1 ;;
            *.bz2)      bunzip2 $1    ;;
            *.gz)       gzip -d $1    ;; # "gunzip" is wrapper for "gzip -d"
            *.rar)      rar x $1      ;;
            *.tar)      tar xf $1     ;;
            *.tar.bz2)  tar xjf $1    ;;
            *.tar.gz)   tar xzf $1    ;;
            *.tar.xz)   tar xf $1     ;;
            *.tbz2)     tar xjf $1    ;;
            *.tgz)      tar xzf $1    ;;
            *.zip)      unzip $1      ;;
            *)          echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
