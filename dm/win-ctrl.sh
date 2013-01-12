#!/bin/bash

xid=`xprop -root _NET_ACTIVE_WINDOW|sed -r '
	s/.*window id # (0x[0-9a-fA-F]+).*/\1/'`

geometry=`xwininfo -stats -id ${xid}|sed -rn '
	s/ *-geometry *([0-9]+)x([0-9]+)[+-]-?[0-9]+[+-]-?[0-9]+.*/rw=\1 rh=\2/ p;
	s/ *Absolute upper-left X: +([0-9]+)/ax=\1/ p;
	s/ *Relative upper-left X: +([0-9]+)/rx=\1/ p;
	s/ *Absolute upper-left Y: +([0-9]+)/ay=\1/ p;
	s/ *Relative upper-left Y: +([0-9]+)/ry=\1/ p;
	s/ *Width: ([0-9]+)/w=\1/ p;
	s/ *Height: ([0-9]+)/h=\1/ p'`

for value in ${geometry}; do
    case ${value} in
	w=*)  geo_w=`echo ${value}|cut -d\= -f2`;;
	h=*)  geo_h=`echo ${value}|cut -d\= -f2`;;
	rw=*) geo_rw=`echo ${value}|cut -d\= -f2`;;
	rh=*) geo_rh=`echo ${value}|cut -d\= -f2`;;
	ax=*) geo_ax=`echo ${value}|cut -d\= -f2`;;
	rx=*) geo_rx=`echo ${value}|cut -d\= -f2`;;
	ay=*) geo_ay=`echo ${value}|cut -d\= -f2`;;
	ry=*) geo_ry=`echo ${value}|cut -d\= -f2`;;
    esac
done

geo_x=$((${geo_ax}-${geo_rx}))
geo_y=$((${geo_ay}-${geo_ry}))

increments=1

while getopts "b:i:m:r:s:" n; do
    case ${n} in
	i) increments="${OPTARG}" ;;
	b) case "${OPTARG}" in
	       left) geo_x=0;;
	       right) geo_x=$((1440-${geo_w}));;
	       up) geo_y=32;;
	       down) geo_y=$((850-${geo_h}));;
           esac;;
	s) case "${OPTARG}" in
	       left) geo_w=$((${geo_w}+${geo_x})); geo_x=0;;
	       right) geo_w=$((1438-${geo_x}));;
	       up) geo_h=$((${geo_h}+${geo_y}-32)); geo_y=32;;
	       down) geo_h=$((850-${geo_y}));;
	   esac;;
	m) case "${OPTARG}" in
	       left) geo_x=$((${geo_x}-${increments}));;
	       right) geo_x=$((${geo_x}+${increments}));;
	       up) geo_y=$((${geo_y}-${increments}));;
	       down) geo_y=$((${geo_y}+${increments}));;
	   esac;;
	r) case "${OPTARG}" in
	       left) [ $geo_w -gt 1 ] && geo_w=$((${geo_w}-${increments}*${geo_w}/${geo_rw}));;
	       right) geo_w=$((${geo_w}+${increments}*${geo_w}/${geo_rw}));;
	       up) [ $geo_h -gt 1 ] && geo_h=$((${geo_h}-${increments}*${geo_h}/${geo_rh}));;
	       down) geo_h=$((${geo_h}+${increments}*${geo_h}/${geo_rh}));;
 	   esac	;;
	\?) echo "Usage: "`basename "${0}"` \
		"[-iINCREMENTS] [-mDIRECTION]... [-rDIRECTION]..."
		exit 1;;
	esac
done

wmctrl -r :ACTIVE: -e "0,${geo_x},${geo_y},${geo_w},${geo_h}"
