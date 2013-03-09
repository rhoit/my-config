#!/bin/bash

function focus {
    activeWinLine=$(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)")
    activeWinId=${activeWinLine:40}
    import -window "$activeWinId" ~/sreenshot_$(date +%Y-%b-%d_%N).png
}

function root {
    import -window root ~/screenshot_$(date +%Y-%b-%d_%N).png
}

case $1 in
	-f|--focus) focus;;
	-r|--root) root;;
esac
