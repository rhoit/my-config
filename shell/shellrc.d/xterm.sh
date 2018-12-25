#!/usr/bin/env bash

function xterm-zsh-keybind-hack {
    # open new xterm on same location
    # simalar to C-S-n in gnome and xfce terminals
    bindkey -s '^N' 'setsid xterm^M'
}

ps -p$PPID | grep xterm > /dev/null && xterm-zsh-keybind-hack
