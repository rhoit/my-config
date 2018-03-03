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


# ** wrapper for bpython
function py {
    ##
    ### python wrapper for multiplexer
    if [[ $# -eq 0 ]]; then
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

# ** bluetooth
function bluetooth-turn-it-on {
    sudo modprobe btusb
    sudo modprobe bluetooth
    sudo systemctl start bluetooth.service
    setsid blueman-manager
}


# ** dlna media-server
function dlna {
    # auto-conf current directory
    cp /etc/minidlna.conf /tmp/dlna.conf
    echo "media_dir=${1:-$PWD}" >> /tmp/dlna.conf

    sudo minidlnad -R -d -f /tmp/dlna.conf
}


# ** woman coz man can not find anything
alias woman="man --apropos $1"


# ** wacom
alias wacom-touch-off='xsetwacom set "Wacom Bamboo 16FG 4x5 Finger pad" touch off'


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
