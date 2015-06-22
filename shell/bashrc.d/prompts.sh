#!/bin/bash

function prompt-def {
    PS1="[\[\033[01;32m\]\u@\h\[\033[01;34m\] \W\[\033[00m\]]\$ "
}


function prompt-git {
    git_path='/usr/share/git/git-prompt.sh'  # missing in ubuntu git package
    if [[ ! -e $git_path  ]]; then
        git_path="/opt/git-prompt.sh"
    fi

    if [[ -e  $git_path ]]; then
        source $git_path
        PS1='[\[\033[01;32m\]\u@\h\[\033[01;34m\] \W\[\e[0;32m\]$(__git_ps1 " (%s)")\[\033[00m\]]\$ '
    else
        prompt-def
    fi
}


prompt-git
