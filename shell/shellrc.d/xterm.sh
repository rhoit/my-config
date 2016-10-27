#!/usr/bin/env bash

function xterm-zsh-keybind-hack {
    bindkey -s '^N' 'setsid xterm^M'
}

ps -p$PPID | grep xterm > /dev/null && xterm-zsh-keybind-hack
