#!/usr/bin/bash
#
# My personal preference
#


# * WINE
# the standard env variable

export WIN="~/.wine/dosdevices/c:"
alias c:="cd $WIN"


# * HELPERS
# bundle up commands for operation

# ** wacom
alias wacom-touch-off='xsetwacom set "Wacom Bamboo 16FG 4x5 Finger pad" touch off'
