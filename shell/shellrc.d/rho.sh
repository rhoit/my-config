#!/bin/bash

#
# My personal preference
#

# My ways
# alias startx='startx &> ~/.xlog'

# Stupid stuffs
alias rc.d='systemctl'

alias rsync="rsync --progress"

# https://imdjh.github.io/toolchain/2015/10/07/drill-if-you-can-dig-if-you-have-to.html
alias dig="echo 'drill if you can, dig if you have to, nslookup if you must'"

function rm {
    # interactive rm
    /usr/bin/rm -v $@
    if [[ "$?" == '1' ]]; then
        echo -n "use 'rmdir'? "
        read reply
        if [[ $reply == "y" || $reply == "Y" || $reply == "" ]]; then
            /usr/bin/rmdir $@
        fi

        echo -n "use 'rm -rf' (yes/no)? "
        read reply
        if [[ $reply == "yes" ]]; then
            /usr/bin/rm -rfv $@
            return $?
        fi
    fi
}


# python
alias py3="python3"
alias pyhost="python3 -m http.server"
alias py2host="/usr/bin/python2 -m SimpleHTTPServer"
alias py2="PYTHONSTARTUP="$HOME/.pythonrc" /usr/bin/python2.7"

function py {
    ##
    ### python wrapper for multiplexer
    if [[ $# -eq 0 ]]; then
        # detect virtual env
        export PYTHONPATH="$(dirname `which python`)/../lib/python3.6/site-packages/"
        echo "venv: $PYTHONPATH"

        # ps -p$PPID | grep gnome-terminal > /dev/null && xterm -ls "bpython" && return
        which bpython && bpython || python
        return
    fi
    python $@
}


export SPARK_HOME="/usr/share/apache-spark/"
export PYSPARK_SUBMIT_ARGS="--master local[4]"
alias pyspark="/usr/share/apache-spark/bin/pyspark"
alias pyspark-notebook="IPYTHON_OPTS='notebook' /usr/share/apache-spark/bin/pyspark"

# mount
# alias mount="mount | column -t | less -S"

# gdb
alias gdb="gdb -q"

# WINE is the standard env variable
export WIN="~/.wine/dosdevices/c:"
alias c:="cd $WIN"


function xdg-give-me-damn-exec {
    (( $# == 0 )) && {
        echo "Usage:"
        echo "  $ xdg-give-me-damn-exec text/x-python"
        return
    }

    local name=$(xdg-mime query default $1)

    for prefix in ~/.local /user /usr/local; do
        local mime="$prefix/share/applications/$name"
        if [[ -f "$mime" ]]; then
            grep "^Exec" $mime
            return
        fi
    done
    >&2 echo "GTFO no mime"
    return 9000
}


function mtp-device-enable-udev {
    local LSUSB=($(lsusb))
    for ((i=0; i < ${#LSUSB}; i++)); do
        echo -e "$i\t${LSUSB[i]}"
    done
    # read -r choice
    # re insert your device
}


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


function emacs {
    # if [[ -t 1 ]]; then
    #     while read data; do
    #         args+="$data"
    #     done
    #     echo "data: ${args[*]}"
    #     # /usr/bin/emacs ${args[*]}
	#     return
    # fi

    ##
    ### emacs wrapper for mulitplexing
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


function nemo {
    ##
    ### nemo (file browser) wrapper
    if [[ $# -eq 0 ]]; then
        setsid /usr/bin/nemo . # "nemo" is function, will cause recursion
    else
        setsid /usr/bin/nemo $@
    fi
}


function nautilus {
    ##
    ### nemo (file browser) wrapper
    if [[ $# -eq 0 ]]; then
        setsid /usr/bin/nautilus . # "nemo" is function, will cause recursion
    else
        setsid /usr/bin/nautilus $@
    fi
}


function ssh-sftp-wrapper {
    ##
    ### ssh wrapper for smart behaviour
    command=$1
    shift
    if [[ $# -eq 0 ]]; then
        /usr/bin/$command # will cause recursion if not
        return
    fi

    /usr/bin/$command $*

    exitcode=$?
    if [[ $exitcode -eq 0 ]]; then
        return 0
    fi

    ## catch error
    /usr/bin/$command $* 2> /tmp/ssh_key_error >/dev/null

    local v=$(sed -n 's/.*known_hosts:\([0-9]*\).*/\1/p' /tmp/ssh_key_error)
    if [[ $v == "" ]]; then
        return $exitcode
    fi

    echo -n "\nDo you wanna fix and continue? "
    read reply
    if [[ $reply == "y" || $reply == "Y" || $reply == "" ]]; then
        local v=$(sed -n 's/.*known_hosts:\([0-9]*\).*/\1/p' /tmp/ssh_key_error)
        sed -i "${v}d" $HOME/.ssh/known_hosts
        /usr/bin/$command $*
        return $?
    fi
}


function ssh {
    if [[ -z $SSH_AUTH_SOCK ]]; then
        echo "ssh-agent daemon not active"
        # gnome-keyring-daemon
        # eval $(ssh-agent -s)
        # ssh-add
    fi
    ssh-add -l | cut -d' ' -f2,3
    ssh-sftp-wrapper ssh $@
}

alias sftp="ssh-sftp-wrapper sftp "


function bluetooth-turn-it-on {
    sudo modprobe btusb
    sudo modprobe bluetooth
    sudo systemctl start bluetooth.service
    setsid blueman-manager
}


function dlna {
    cp /etc/minidlna.conf /tmp/dlna.conf
    echo "media_dir=${1:-$PWD}" >> /tmp/dlna.conf
    sudo minidlnad -d -f /tmp/dlna.conf
}


function frontmacs {
    env HOME=/home/rho/.emacs.d/frontmacs emacs
}


function doomemacs {
    env HOME=/home/rho/.emacs.d/doom emacs
}


function ydl {
    local list=$(youtube-dl --list-formats $1)

    echo $list | sed -n '/[0-9]x[0-9]/p'
    echo -n "video format (default=244, skip=0): "; read video
    if [[ "$video" == 0 ]]; then
        video=""
    else
        video="${video:-244}+"
    fi

    echo $list | sed -n '/audio only/p'
    echo -n "audio format (default=250, skip=0): "; read audio
    if [[ "$audio" == 0 ]]; then
        audio=""
    else
        audio="${audio:-250}"
    fi

    youtube-dl --format "${video}${audio}" $1
}
