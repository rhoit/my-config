#!/bin/bash


# alias from oh-my-zsh plugin zsh-git
alias gst='git status'
alias gd='git diff'
alias gdca='git diff --cached'
alias gco='git checkout'
alias gcm='git checkout master'
alias grv='git remote -v'
alias gba='git branch -a'
alias glo='git log --oneline --decorate --color'
alias glol='git log --graph --pretty=format:'\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit'


function prompt-def {
    PS1="[\[\033[01;32m\]\u@\h\[\033[01;34m\] \W\[\033[00m\]]\$ "
}


function prompt-git {
    source '/usr/share/git/git-prompt.sh'  # missing in ubuntu git package
    PS1='[\[\033[01;32m\]\u@\h\[\033[01;34m\] \W\[\e[0;32m\]$(__git_ps1 " (%s)")\[\033[00m\]]\$ '
}


prompt-git
