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


function notes-x2x {
    echo "echo 'X11Forwarding yes' > /etc/ssh/ssh_config.d/X11Forward "
    echo " west north east"
    echo "    ←   ↑   →   "
    echo "ssh [username]@[hostname] -Y x2x -to :0 -east"
}


function notes-ssh {
    echo "ssh -ND <port> <host>  # create SOCK5 tunnel on localhost:<port>"
    echo "ssh -N -f -L 3389:localhost:3389 telescope.fqdn  # reverse Tunnel"
}


function notes-pacman {
    echo "pacman --sync|-S --clean|-c --clean|-c  # clean cache"
    echo "pacman --query|-Q --foreign|-m  # helpful to find aur packages"
}
