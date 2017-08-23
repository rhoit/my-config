#!/bin/bash

# * Generic config

git config --global core.editor mg
git config --global color.ui true
git config --global color.diff.old "red bold"
git config --global color.diff.new "green italic"
git config --global push.default simple # git 2.0 fix warnings

if [ -e ~/.gitconfig ]; then
    echo "Wow! You had already configure git, press enter if you don't want to change"
    d_uname=$(git config --get user.name)
    d_email=$(git config --get user.email)
    d_hub_user=$(git config --get github.user)
fi

echo "* Git User Setup"
read -p "    Username (current: $d_uname) :" uname
read -p "    E-mail (current: $d_email) :" email

git config --global user.name "${uname:-$d_uname}"
git config --global user.email "${email:-$d_email}"

# * Github config

read -p "Do you want to config for github (y/n):" r
if [[ "$r" == "" || "$r" == "Y" || "$r" == 'y' ]]; then
    true
else
    exit
fi

echo "* Github gist Setup"
read -p "    github-username: $d_hub_user" hub_user
read -sp "    github-password: " hub_pass; echo

curl -u "${hub_user:=$d_hub_user}:${hub_pass}"\
     -X GET /authorizations\
     https://api.github.com/authorizations

exit

curl -u "${hub_user:=$d_hub_user}:${hub_pass}"\
     -H "Content-Type: application/json"\
     -X POST\
     -d '{"scopes":["gist"], "note": "gist"}'\
     https://api.github.com/authorizations > /tmp/gitapi

cat /tmp/gitapi

token=$(sed -n '/"token"/s/.*: "\(.*\)",/\1/p' /tmp/gitapi)
echo $token

git config --global github.user "$hub_user"
git config --global github.gist-oauth-token "$token"
