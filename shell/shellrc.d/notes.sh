#!/bin/bash

#
# notes
# nifty thing cheatsheet


function notes-ffmpeg {
    echo "* probe file"
    echo ffprobe video.webm
    echo

    echo "* entract audio"
    echo ffmpeg -i video.mkv -map 0:a -acodec copy audio.mp4
    echo ffmpeg -i video.mkv -map 0:a -acodec libmp3lame audio.mp3
    echo

    echo "* re-encode"
    echo ffmpeg -i input.file -codec:a aac -codec:v libx264  output.mp4
    echo

    echo "* png to webm"
    echo ffmpeg -i input%04d.png output.webm
    echo
}


function notes-wifi {
    echo "* wifi-qr"
    echo nmcli dev wifi show-password
    echo qrencode -t ANSI "WIFI:S:SSID;T:{WPA|WEP};P:PASSWORD;;"
}
