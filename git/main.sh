#!/usr/bin/bash

set -e

# https://www.git-scm.com/book/en/v2/Customizing-Git-Git-Configuration

# * GENERIC CONFIG

git config --global core.editor mg
git config --global color.ui true
git config --global push.default simple # git 2.0 fix warnings


# * GIT USER SETUP
echo "* GIT USER SETUP"

d_UNAME=$(git config --get user.name)
d_EMAIL=$(git config --get user.email)

if [[ -e ~/.gitconfig ]]; then
    echo "press enter if you don't want to change"
fi

read -r -p "    Username (current: $d_UNAME): " uname
read -r -p "    E-mail (current: $d_EMAIL): " email

git config --global user.name "${uname:-$d_UNAME}"
git config --global user.email "${email:-$d_EMAIL}"


d_GITHUB=$(git config --get github.user)
echo '* Github gist Setup'
read -p "    github-username: $d_GITHUB" hub_user
read -sp "    github-password: " hub_pass; echo

curl -u "${hub_user:=$d_GITHUB}:${hub_pass}"\
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
