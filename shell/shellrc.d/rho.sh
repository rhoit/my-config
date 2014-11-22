#!/usr/bin/bash
#
# My personal preference
#


alias woman="man --apropos $1"


# python
alias py="python"
alias py2="PYTHONSTARTUP="$HOME/.pythonrc" python2"
alias py3="python3"


# WINE is the standard env variable
export WIN="~/.wine/dosdevices/c:"
alias c:="cd $WIN"


# * WRAPPERS
# extend application options

alias gdb="gdb -q"


function nemo {
    ##
    ### nemo (file browser) wrapper
    if [[ $# -eq 0 ]]; then
        setsid /usr/bin/nemo . # "nemo" is function, will cause recursion
    else
        setsid /usr/bin/nemo $@
    fi
}


function ssh {
    ##
    ### ssh wrapper for smart behaviour
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
