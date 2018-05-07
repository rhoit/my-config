#!/bin/bash

#
# My personal preference
#

# * DEFAULTS

export EDITOR="mg"
export VISUAL="mg"
export SCREEN="tmux"
export BROWSER="chromium"


# * PYTHON

alias py3="python3"
alias py2="PYTHONSTARTUP="$HOME/.pythonrc" /usr/bin/python2.7"

function py {
    ##
    ### python wrapper for multiplexer

    # TODO: detect virtual env
    # PYTHONPATH=venv/lib/python3.6/site-packages/ bpython

    if [[ $# -eq 0 ]]; then
        # ps -p$PPID | grep gnome-terminal > /dev/null && xterm -ls "bpython" && return
        which bpython && bpython || python
        return
    fi
    python $@
}

# ** spark

export SPARK_HOME="/usr/share/apache-spark/"
export PYSPARK_SUBMIT_ARGS="--master local[4]"
alias pyspark="/usr/share/apache-spark/bin/pyspark"
alias pyspark-notebook="IPYTHON_OPTS='notebook' /usr/share/apache-spark/bin/pyspark"

# * EMACS

function emacs-doom {
    env HOME=/home/rho/.config/emacs-doom emacs
}


function emacs {
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

# * HELPERS
# bundle up commands for operation

# ** mtp

function mtp-device-enable-udev {
    local LSUSB=($(lsusb))
    for ((i=0; i < ${#LSUSB}; i++)); do
        echo -e "$i\t${LSUSB[i]}"
    done
    # read -r choice
    # re insert your device
}

# ** bluetooth

function bluetooth-turn-it-on {
    sudo modprobe btusb
    sudo modprobe bluetooth
    sudo systemctl start bluetooth.service
    setsid blueman-manager
}
# ** media-server

function dlna {
    cp /etc/minidlna.conf /tmp/dlna.conf
    echo "media_dir=${1:-$PWD}" >> /tmp/dlna.conf

    sudo minidlnad -R -d -f /tmp/dlna.conf
}

# ** youtube-dl

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
