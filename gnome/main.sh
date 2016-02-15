#!/bin/bash

# Sample
# gsettings set org.gnome.desktop.default-applications.terminal exec konsole
# gsettings set org.gnome.desktop.default-applications.terminal exec-arg "'-e'"

# pdf: evince
#cp ~/.local/share/applications/mimeapps.list .

# * gnome-terminal configs
function gnome-terminal-config {
    # data are stored in ~/.gconf/apps/gnome-terminal
    gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar "false"
    gsettings set org.gnome.Terminal.Legacy.Settings mnemonics-enabled "false"

    profile=$(dconf list /org/gnome/terminal/legacy/profiles:/)
    if [[ "${profile:0:1}" != ":" ]]; then
        echo "profile not found"
        return
    fi

    dconf write /org/gnome/terminal/legacy/profiles:/${profile}background-color "'rgb(0,0,0)'"
    dconf write /org/gnome/terminal/legacy/profiles:/${profile}use-theme-colors "false"
    dconf write /org/gnome/terminal/legacy/profiles:/${profile}scrollback-lines "9999"
    dconf write /org/gnome/terminal/legacy/profiles:/${profile}foreground-color "'rgb(255,255,255)'"
}

gnome-terminal-config
