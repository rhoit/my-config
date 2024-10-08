#!/bin/bash

#
# tricks
# handy shortcuts more verbose with colors

# systemctl force color
export SYSTEMD_COLORS=1

# grep
# using ripgrep instead of gnu grep
# https://github.com/BurntSushi/ripgrep
if test -e /usr/bin/rg; then
    alias grep='rg'
else
    alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
fi

# ls
# https://the.exa.website
test -e /usr/bin/exa && {
    alias l='exa -F'
    alias ll='exa -lF'
    alias la='exa -aF'
    alias lla='exa -aFl'
    alias lg='exa -aFl --git'
    alias ltree='exa --long --tree'
}

# df hide tmpfs
alias df='df -h -x tmpfs '

# cat as bat is less than more
if test -e /usr/bin/bat; then
    alias less='bat'
else
    # show colors
    alias less='/usr/bin/less --raw-control-chars'
fi

# cd
alias ..='cd ..'

# diff
alias diff='colordiff '

# watch
alias watch='watch --color '

# Using sudo with alias
alias sudo='sudo -E '

# she know all (kinda from emacs)
alias woman="man --apropos $1"

# history
alias hist='history | grep '

# lazy conf
function run { chmod +x "$@" && ./$1; }
function mkcd { mkdir -p "$1" && cd "$1"; }

# make thing verbose
alias cp='cp -v'
alias mv='mv -v'
alias rsync="rsync --progress"


function rm {
    # interactive rm
    /usr/bin/rm -v $@
    if [[ "$?" == '1' ]]; then
        echo -n "use 'rmdir'? "
        read reply
        if [[ $reply == "y" || $reply == "Y" || $reply == "" ]]; then
            /usr/bin/rmdir $@
        fi

        echo -n "use 'rm -rf' (yes/no)? "
        read reply
        if [[ $reply == "yes" ]]; then
            /usr/bin/rm --recursive --verbose --force $@
            return $?
        fi
    fi
}


function mic2speaker {
    ## loudSpeak with lots of echos

    arecord -f cd - | aplay -
    # wanna save it too
    # arecord -f cd - | tee output.wav | aplay -
}


function xdg-give-me-damn-exec {
    (( $# == 0 )) && {
        echo "Usage:"
        echo "  $ xdg-give-me-damn-exec text/x-python"
        return
    }

    local name=$(xdg-mime query default $1)

    for prefix in ~/.local /user /usr/local; do
        local mime="$prefix/share/applications/$name"
        if [[ -f "$mime" ]]; then
            grep "^Exec" $mime
            return
        fi
    done
    >&2 echo "GTFO no mime"
    return 9000
}
