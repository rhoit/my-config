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
