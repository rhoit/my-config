#!/bin/bash

#
# Bash tricks
# handy shortcuts for basic commands and enable color

# ls
alias l='ls -CFh'
alias ll='ls -lFh'
alias la='ls -AFh'
alias lla='ls -aFlh'

# grep
alias grep='grep --color=auto '
alias ggrep='grep --exclude-dir={.git} '

# cd
alias ..='cd ..'

# diff
alias diff='colordiff '

# watch
alias watch='watch --color '

# systemctl force color
export SYSTEMD_COLORS=1

# Using sudo with alias
alias sudo='sudo -E '

# she know all (kinda from emacs)
alias woman="man --apropos $1"

# lazy conf
## Don't make one-liner bash does't support it
function run {
    chmod +x "$@" && ./$1
}

function mkcd {
    mkdir -p "$1" && cd "$1"
}

#----------------------------------------------------------------------
# COMPOSITE ALIAS

# ls | grep
alias lgrep='ls | grep '
alias lagrep='ls -a | grep '

# history
alias hist='history | grep '
