#!/bin/bash

if [ -e ~/.gitconfig ]; then
    read -p "Username: " uname
    read -p "E-mail: " email
    git config --global user.name "$uname"
    git config --global user.email "$email"
fi

git config --global core.editor "nano"
git config --global color.ui true
git config --global push.default simple # changed with git 2.0 setting simple to hide pop-up warnings

cp /usr/share/git/git-prompt.sh ~/.bashrc.d/git-prompt
chmod +x ~/.bashrc.d/git-prompt

