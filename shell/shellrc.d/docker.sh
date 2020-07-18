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
        s/ months\?/M/g;
        s/ years\?/Y/g;
        s/About an\?/1/g;
        s/Exited (\([0-9]\+\)) \(.*\)ago/exit(\1)~\2/; # for ps
        s/->/→/g;
        s/\/bin\/sh -c #(nop) *//g;
        ' |
    sed "s/  \+/;/g" |
    column -s\; -t |
    sed "1s/.*/\x1B[1m&\x1B[m/"  # make headers bold
    tput smam # line-wrap on
}


function docker-none-tag-image-drop {
    docker images --format='{{.ID}}\t{{.Tag}}' | grep '<none>' | cut -f1 | xargs docker rmi
}


function docker-clean-exited-containers {
    docker ps --all --quiet --filter status=exited | xargs -n1 docker rm
}


alias dip="docker-get-ip-latest"
function docker-get-ip-latest () {
    docker ps --quiet | xargs docker inspect --format '{{.NetworkSettings.IPAddress}} {{.Config.Hostname}} {{.Name}}'
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


alias drun='docker run'
alias drace='docker run --rm'
alias dstop='docker stop'
alias dexec='docker exec'
alias dtty='docker run --interactive --tty'

alias dtop='docker_fit top'
alias dimg='docker_fit images'
alias dll='docker_fit ps --latest'
alias dps='docker_fit ps --all'
alias dhist='docker_fit history'
alias dvol='docker_fit volume ls'

alias dc='docker-compose'
