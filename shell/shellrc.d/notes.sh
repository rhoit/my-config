#!/bin/bash

#
# notes
# nifty thing cheatsheet


function notes-ffmpeg {
    echo re-encode
    echo ffmpeg -i input.file -codec:a aac -codec:v libx264  output.mp4
    echo
    echo png to webm
    echo ffmpeg -i input%04d.png output.webm
}


function notes-wifi {
    echo wifi-qr
    echo nmcli dev wifi show-password
    echo qrencode -t ANSI "WIFI:S:SSID;T:{WPA|WEP};P:PASSWORD;;"
}


function notes-input {
    echo /usr/share/X11/locale/en_US.UTF-8/Compose
}
