#!/bin/bash

function docker_fit {
    # docker fit output
    tput rmam # line-wrap off
    docker $@ | sed '
        1s/ *NAMES$//g;          # for ps
        s/ *[a-z]\+_[a-z]\+$//g;
        s/"\(.*\)"/\1/g;         # for ps
        s/ seconds\?/s/g;
        s/ minutes\?/m/g;
        s/ hours\?/h/g;
        s/ days\?/d/g;
        s/ weeks\?/w/g;
        s/ months\?/m/g;
        s/About an\?/1m/g;
        s/Exited (\([0-9]\+\)) \(.*\)ago/exit(\1)~\2/;
        s/->/→/g
        ' |
    sed "s/  \+/;/g" |
    column -s\; -t |
    sed "1s/.*/\x1B[1m&\x1B[m/"
    tput smam # line-wrap on
}


function dlc {
    # cache docker last container id DOCKER_CACHE
    1>&2 docker ps -l
    export DOCKER_CACHE=$(docker ps -lq)
}


function dlo {
    if [[ -t 1 ]]; then
        while read data; do
            args+="$data"
        done
        docker logs $args
        return
    fi
    if [[ $DOCKER_CACHE != "" ]]; then
        docker logs $DOCKER_CACHE
        return
    fi
    docker logs $@
}
