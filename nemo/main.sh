#!/usr/bin/bash


# for gui use dconf-editor

gsettings set org.nemo.desktop show-desktop-icons false
gsettings set org.nemo.preference.show-location-entry false  # show bread-crumb
gsettings set org.cinnamon.desktop.default-applications.terminal exec xfce4-terminal
