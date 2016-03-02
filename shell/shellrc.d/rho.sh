#!/usr/bin/bash
#
# My personal preference
#


# Stupid stuffs
alias pm='pacman'
alias woman="man --apropos $1"

# python
alias py3="python3"
alias pysrv="python3 -m http.server"
alias py2srv="/usr/bin/python2 -m SimpleHTTPServer"
alias py2="PYTHONSTARTUP="$HOME/.pythonrc" /usr/bin/python2.7"

function py {
    ##
    ### python wrapper for multiplexer
    if [[ $# -eq 0 ]]; then
        which bpython && bpython || python
        return
    fi
    python $@
}

export SPARK_HOME="/usr/share/apache-spark/"
export PYSPARK_SUBMIT_ARGS="--master local[4]"
alias pyspark="/usr/share/apache-spark/bin/pyspark"
alias pyspark-notebook="IPYTHON_OPTS='notebook' /usr/share/apache-spark/bin/pyspark"


# WINE is the standard env variable
export WIN="~/.wine/dosdevices/c:"
alias c:="cd $WIN"


function readlink {
    if [[ -t 1 ]]; then
        while read data; do
            args+="$data"
        done
        /usr/bin/readlink ${args[*]}
	    return
    fi

    if [[ $# -gt 0 ]]; then
        /usr/bin/readlink $@
    fi
}


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
