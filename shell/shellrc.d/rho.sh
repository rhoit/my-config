#!/usr/bin/bash
#
# My personal preference
#


alias woman="man --apropos $1"


# python
alias py="python"


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
