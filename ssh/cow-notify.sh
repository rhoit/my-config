#!/bin/sh

export XAUTHORITY="/home/rho/.Xauthority"
export DISPLAY=:0 

if [ "$PAM_TYPE" != "close_session" ]; then
    message="$PAM_TTY $PAM_USER@$(hostname) from $PAM_RHOST"
    /usr/bin/xcowsay $message &
fi

