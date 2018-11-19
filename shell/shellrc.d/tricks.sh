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
alias l='ls -CFh'
alias ll='ls -lFh'
alias la='ls -AFh'
alias lla='ls -aFlh'
alias lgrep='ls | grep '
alias lagrep='ls -a | grep '

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
