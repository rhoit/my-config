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

# watch, expand alias arguments
alias watch='watch -c '

# Using sudo with alias
alias sudo='sudo -E '

# she know all (kinda from emacs)
alias woman="man --apropos $1"


#----------------------------------------------------------------------
# COMPOSITE ALIAS

# ls | grep
alias lgrep='ls | grep '
alias lagrep='ls -a | grep '

# history
alias hist='history | grep '
