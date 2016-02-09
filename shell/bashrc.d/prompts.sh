#!/bin/bash

function prompt-def {
    PS1="[\[\033[01;32m\]\u@\h\[\033[01;34m\] \W\[\033[00m\]]\$ "
}


function prompt-git {
    source '/usr/share/git/git-prompt.sh'  # missing in ubuntu git package
    PS1='[\[\033[01;32m\]\u@\h\[\033[01;34m\] \W\[\e[0;32m\]$(__git_ps1 " (%s)")\[\033[00m\]]\$ '
}


prompt-git
