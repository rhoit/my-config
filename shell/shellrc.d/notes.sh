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


function notes-input {
    echo /usr/share/X11/locale/en_US.UTF-8/Compose
}


function notes-bootable {
    echo https://wiki.archlinux.org/title/USB_flash_installation_medium
    echo dd status=progress bs=4M conv=fsync oflag=direct if=archlinux-2024.12.01-x86_64.iso of=/dev/sda
}
