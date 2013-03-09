#!/bin/bash

state="$(synclient | sed -n 's/ //; s/.*TouchpadOff.*= //p')"
echo $state
if [ "$state" = "0" ] ; then
    synclient TouchpadOff="1"
    #echo 1 > /sys/class/leds/dell-laptop::touchpad/brightness
else
    synclient TouchpadOff="0"
    #echo 0 > /sys/class/leds/dell-laptop::touchpad/brightness
fi

