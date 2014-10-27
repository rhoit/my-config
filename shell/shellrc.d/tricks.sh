#!/bin/bash

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ls
alias l='ls -CF'
alias ll='ls -lF'
alias la='ls -A'
alias lla='ls -al'

# find
alias lgrep='ls | grep $1'
alias lagrep='ls -a | grep $1'

# cd
alias ..='cd ..'

# diff
alias diff='colordiff'

# history
alias hist='history | grep $1'
alias openports='netstat --all --numeric --programs --inet --inet6'

### Using sudo with alias ###
# Neat trick - also given in arch-wiki
alias sudo='sudo -E '
