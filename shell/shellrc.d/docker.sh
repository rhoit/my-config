#!/bin/bash


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
