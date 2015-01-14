#!/bin/bash

#
# My personal preference
#

alias run="chmod +x"
alias woman="man --apropos $1"

# My ways
alias startx='startx &> ~/.xlog'

# Stupid stuffs
alias rc.d='systemctl'

# python
alias py="python"
alias py3="python3"
alias pysrv="python3 -m http.server"
alias py2srv="python2 -m SimpleHTTPServer"

# everything do with py2
alias py2='PYTHONSTARTUP="$HOME/.pythonrc" python2'
alias python2='PYTHONSTARTUP="$HOME/.pythonrc" python2'
alias python2.7='PYTHONSTARTUP="$HOME/.pythonrc" python2'

# gdb
alias gdb="gdb -q"

# WINE is the standard env variable
export WIN="~/.wine/dosdevices/c:"
alias c:="cd $WIN"

# ibus
export XMODIFIERS=@im=ibus
export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus

# mkdir and cd
mkcd () { mkdir -p "$@" && cd "$@"; }

# emacs behaviour
function emacs {
    if [[ $# -eq 0 ]]; then
        /usr/bin/emacs # "emacs" is function, will cause recursion
        return
    fi

    args=($*)
    # TIP: add '-' arguement for opening new emacs session
    for ((i=0; i <= ${#args}; i++)); do
        local a=${args[i]}
        # NOTE: -c create frame; -nw: no-window
        if [[ ${a:0:1} == '-' && $a != '-c' ]]; then
            # TIPS: -nw will not work with setsid use '&'
            /usr/bin/emacs ${args[*]}
            return
        fi
    done

    setsid emacsclient -n -a /usr/bin/emacs ${args[*]}
}

# file browser (nemo) behaviour
function nemo {
    if [[ $# -eq 0 ]]; then
        setsid /usr/bin/nemo . # "nemo" is function, will cause recursion
    else
        setsid /usr/bin/nemo $@
    fi
}

# ssh behaviour
function ssh {
    if [[ $# -eq 0 ]]; then
        /usr/bin/ssh # "ssh" is function, will cause recursion
        return
    fi

    /usr/bin/ssh $* 2> /tmp/ssh_key_error
    exitcode=$?
    if [[ $exitcode -eq 0 ]]; then
        return 0
    fi

    cat /tmp/ssh_key_error
    local v=$(sed -n 's/.*known_hosts:\([0-9]*\).*/\1/p' /tmp/ssh_key_error)
    if [[ $v == "" ]]; then
        return $exitcode
    fi

    echo -n "\nDo you wanna fix and continue? "
    read reply
    if [[ $reply == "y" || $reply == "Y" || $reply == "" ]]; then
        local v=$(sed -n 's/.*known_hosts:\([0-9]*\).*/\1/p' /tmp/ssh_key_error)
        sed -i "${v}d" $HOME/.ssh/known_hosts
        /usr/bin/ssh $*
        return $?
    fi
}
