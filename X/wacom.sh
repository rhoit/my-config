#!/bin/sh
# First button of the stylus as a Control Click

#xsetwacom set "Wacom Intuos3 9x12" button2 "core key Control"

#[rho@turion ~]$ xsetwacom --list devices
# Wacom Bamboo 16FG 4x5 Finger touch	id: 18	type: TOUCH     
# Wacom Bamboo 16FG 4x5 Finger pad	id: 19	type: PAD       
# Wacom Bamboo 16FG 4x5 Pen stylus	id: 20	type: STYLUS    
# Wacom Bamboo 16FG 4x5 Pen eraser	id: 21	type: ERASER    

xsetwacom set "Wacom BambooFun 16FG 4x8" button2 "core key Control"  

xsetwacom --set "Wacom Bamboo 16FG 4x5 Finger pad" touch off
