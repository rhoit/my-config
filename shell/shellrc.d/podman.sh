#!/bin/bash


function podman_fit {
    # docker fit output
    tput rmam # line-wrap off
    podman $@ | sed '
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


function podman-none-tag-image-drop {
    podman images --format='{{.ID}}\t{{.Tag}}' | grep '<none>' | cut -f1 | xargs podman rmi
}


function podman-clean-exited-containers {
    podman ps --all --quiet --filter status=exited | xargs -n1 podman rm
}


alias podip="podman-get-ip-latest"
function podman-get-ip-latest () {
    podman inspect --latest | grep IPAddress
}


alias podll='podman logs -l'
alias podlog='podman logs'
alias podrun='podman run'
alias podrace='podman run --rm'
alias podstop='podman stop'
alias podexec='podman exec'
alias podtty='podman run --interactive --tty'

alias podtop='podman top'
alias podimg='podman images'
alias podps='podman ps --all'
