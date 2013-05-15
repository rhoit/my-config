#!/bin/bash

if [ ! -e ~/.gitconfig ]; then
    echo "Git User Setup"
    read -p "    Username: " uname
    read -p "    E-mail: " email
    git config --global user.name "$uname"
    git config --global user.email "$email"
    echo "github gist Setup"
    read -p "    github-username: " uname
    read -sp "    github-password: " pass; echo
    curl -u $uname:"$pass"\
         -H "Content-Type: application/json"\
         -X POST\
         -d '{"scopes":["gist"], "note": "gist"}'\
         https://api.github.com/authorizations > /tmp/gitapi
    cat /tmp/gitapi
    token=$(sed -n '/token/s/.*: "\(.*\)",/\1/p' /tmp/gitapi)
    echo $token
    git config --global github.user "$uname"
    git config --global github.gist-oauth-token "$token"
fi

git config --global core.editor "nano"
git config --global color.ui true
git config --global push.default simple # git 2.0 fix warnings
