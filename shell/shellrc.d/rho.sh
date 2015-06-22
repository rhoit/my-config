#!/usr/bin/bash
#
# My personal preference
#

# * PYTHON

alias py3="python3"
alias pyhost="python3 -m http.server"
alias py2host="python2 -m SimpleHTTPServer"

alias py2='PYTHONSTARTUP="$HOME/.pythonrc" python2'
alias python2='PYTHONSTARTUP="$HOME/.pythonrc" python2'
alias python2.7='PYTHONSTARTUP="$HOME/.pythonrc" python2'


function py {
    ##
    ### python wrapper for multiplexer
    if [[ $# -gt 0 ]]; then
        python $@
        return
    fi
    which bpython && bpython || python
}


# * WINE
# the standard env variable

export WIN="~/.wine/dosdevices/c:"
alias c:="cd $WIN"


# * WRAPPERS
# extend application options

# ** nemo
function nemo {
    ##
    ### nemo (file browser) wrapper
    if [[ $# -eq 0 ]]; then
        setsid /usr/bin/nemo . # "nemo" is function, will cause recursion
    else
        setsid /usr/bin/nemo $@
    fi
}


# * HELPERS
# bundle up commands for operation

# ** woman coz man can not find anything
alias woman="man --apropos $1"


# ** wacom
alias wacom-touch-off='xsetwacom set "Wacom Bamboo 16FG 4x5 Finger pad" touch off'
