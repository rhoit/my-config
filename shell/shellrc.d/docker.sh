#!/bin/bash

function docker_fit {
    # docker fit output
    tput rmam # line-wrap off
    docker $@ | sed '
        1s/ *NAMES$//g;          # remove NAMES from ps
        s/ *[a-z]\+_[a-z]\+$//g; # remove NAMES from ps

        s/"\(.*\)"/\1/g;         # remove quotes from ps
        s/ seconds\?/s/g;
        s/ minutes\?/m/g;
        s/ hours\?/h/g;
        s/ days\?/d/g;
        s/ weeks\?/w/g;
        s/ months\?/m/g;
        s/About an\?/1/g;
        s/Exited (\([0-9]\+\)) \(.*\)ago/exit(\1)~\2/; # for ps
        s/->/→/g
        ' |
    sed "s/  \+/;/g" |
    column -s\; -t |
    sed "1s/.*/\x1B[1m&\x1B[m/"  # make headers bold
    tput smam # line-wrap on
}

function dlc {
    # cache docker last container id DOCKER_CACHE
    1>&2 docker ps --latest
    export DOCKER_CACHE=$(docker ps --latest --quiet)
}

function dlog {
    # docker logs
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


function dins {
    docker inspect $1 | jq
}



alias dpull='docker pull'
alias dinfo='docker info'
alias drun='docker run'
alias drace='docker run --rm'
alias dstop='docker stop'
alias dexec='docker exec'
alias dl='docker ps --latest --quiet'
alias dtty='docker run --interactive --tty'

# alias dlins="docker inspect $(dl) | jq"



alias dc='docker-compose'

alias dtop='docker_fit top'
alias dimg='docker_fit images'
alias dll='docker_fit ps --latest'
alias dps='docker_fit ps --all'
alias docker-clean-exited-containers='docker ps --all --quiet --filter status=exited | xargs -n1 docker rm'
