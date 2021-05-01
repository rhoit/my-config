#!/usr/bin/bash

set -e

# https://www.git-scm.com/book/en/v2/Customizing-Git-Git-Configuration

# * GENERIC CONFIG

git config --global core.editor mg
git config --global color.ui true
git config --global color.diff.old "red bold"
git config --global color.diff.new "green italic"
git config --global diff.colormoved default

git config --global push.default simple # git 2.0 fix warnings
git config --global pull.rebase true

# git config --global core.whitespace trailing-space,-space-before-tab,indent-with-non-tab,tab-in-indent,cr-at-eol
# git config --global core.whitespace -space-before-tab,indent-with-non-tab,tab-in-indent,cr-at-eol

# https://www.git-scm.com/book/en/v2/Git-Tools-Signing-Your-Work#_signing
# git config --global user.signingkey <gpg-key-id>

git config --global core.attributesfile "${PWD}/gitattributes"


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


# * bash prompt

link="https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh"
[[ "$OFFLINE" == "1" ]] || {
    [ -e /usr/share/git/git-prompt.sh ] ||  wget -c $link -O /tmp/git-prompt.sh
}

# * GITHUB CONFIG

read -r -p "Do you want to config for github (y/n):" r
if [[ "$r" == "" || "$r" == "Y" || "$r" == 'y' ]]; then
    true
else
    exit
fi

d_GITHUB=$(git config --get github.user)
echo '* Github gist Setup'
read -p "    github-username: $d_GITHUB" hub_user
read -sp "    github-password: " hub_pass; echo

curl -u "${hub_user:=$d_GITHUB}:${hub_pass}"\
     -X GET /authorizations\
     https://api.github.com/authorizations
