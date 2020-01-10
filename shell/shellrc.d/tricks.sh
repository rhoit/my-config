#!/bin/bash

#
# tricks
# handy shortcuts more verbose with colors

# systemctl force color
export SYSTEMD_COLORS=1

# grep
alias grep='grep --color=auto '
alias ggrep='grep --exclude-dir={.git} '

# ls
# https://the.exa.website
alias l='exa -F'
alias ll='exa -lF'
alias la='exa -aF'
alias lla='exa -aFl'
alias lg='exa -aFl --git'
alias ltree='exa --long --tree'

# df hide tmpfs
alias df='df -h -x tmpfs '

# cat as bat is less than more
>/dev/null which bat && alias less='bat'

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
            /usr/bin/rm -rfv $@
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
