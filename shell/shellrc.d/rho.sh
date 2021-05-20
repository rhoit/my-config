#!/bin/bash

#
# My personal preference
#

# * CONFIGS
# ** default apps

export EDITOR="mg"
export VISUAL="mg"
export SCREEN="tmux"
export BROWSER="chromium"

# ** wine
# the standard env variable

export WIN="~/.wine/dosdevices/c:"
alias c:="cd $WIN"

# * PYTHON

alias py3="python3"
alias pyhost="python3 -m http.server"
alias py2host="/usr/bin/python2 -m SimpleHTTPServer"
alias py2="PYTHONSTARTUP="$HOME/.py2rc" /usr/bin/python2.7"

function py {
    ##
    ### python wrapper for multiplexer
    if [[ $# -eq 0 ]]; then
        # detect virtual env
        local VER=$(python -c "import sys; print('{v.major}.{v.minor}'.format(v=sys.version_info))")
        export PYTHONPATH="$(dirname `which python`)/../lib/python${VER}/site-packages/"
        echo "venv: $PYTHONPATH"

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

# * WRAPPERS
# extend application options

# ** mount

function mount {
    if [[ $# -eq 0 ]]; then
        /usr/bin/mount | column -t | less -S
        return
    fi

    /usr/bin/mount $*
}

# ** gdb

alias gdb="gdb -q"

# ** readlink

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


# ** emacs

function emacs-doom {
    env HOME=/home/rho/.emacs.d/doom emacs
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

# ** file manager

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
    ### nautilus (file browser) wrapper
    if [[ $# -eq 0 ]]; then
        setsid /usr/bin/nautilus . # "nemo" is function, will cause recursion
    else
        setsid /usr/bin/nautilus $@
    fi
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
        video="${video:-244}"
    fi

    echo $list | sed -n '/audio only/p'
    total=$(echo $list | sed -n '/audio only/p' | wc -l)
    # TODO: check 250 is in or not
    echo -n "audio format (default=250, skip=0): "; read audio
    if [[ "$audio" == 0 ]]; then
        audio=""
    else
        audio="${audio:-250}"
        if [[ "$video" != "" ]]; then
            audio="+$audio"
        fi
    fi

    echo youtube-dl --format "${video}${audio}" $@
    youtube-dl --format "${video}${audio}" $@
}

# * HELPERS
# bundle up commands for operation

# ** xdg

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


# ** mtp

function mtp-device-enable-udev {
    local LSUSB=($(lsusb))
    for ((i=0; i < ${#LSUSB}; i++)); do
        echo -e "$i\t${LSUSB[i]}"
    done
    # read -r choice
    # re insert your device
}

# ** randpass

function randpass {
    echo "use: pwgen"
    echo "use: openssl -rand -base64 30"
    # random password of desired length
    < /dev/urandom tr -dc '_A-Z-a-z-0-9+-~!@#$%^&*()_+=-'| head -c${1:-16};echo;
    # openssl rand -base64 |head -c${1:-16};echo;
}

# ** drm

function audible-remove-drm {
    (( $# == 0 )) && {
        echo "Usage:"
        echo "  $ audible admhelper"
        return
    }
    # git clone https://github.com/inAudible-NG/audible-activator
    # you will need activation key extractor
    wget -c "http://cdl.audible.com/cgi-bin/aw_assemble_title_dynamic.aa?$(cat $1)" -O "/tmp/$1.aax"
    ffmpeg -y -activation_bytes $KEY_AUDIBLE -i "/tmp/$1.aax" -c:a copy -vn "$1.m4a"
}

# ** ffmpeg

function ffmpeg-samples {
    echo re-encode
    echo ffmpeg -i input.file -codec:a aac -codec:v libx264  output.mp4
}

# ** bluetooth

function bluetooth-turn-it-on {
    sudo modprobe btusb
    sudo modprobe bluetooth
    sudo systemctl start bluetooth.service
    setsid blueman-manager
}
