#!/bin/bash

# Sample
# gsettings set org.gnome.desktop.default-applications.terminal exec konsole
# gsettings set org.gnome.desktop.default-applications.terminal exec-arg "'-e'"

# pdf: evince
# cp ~/.local/share/applications/mimeapps.list .

function gnome-terminal-conf {
    # data are stored in ~/.gconf/apps/gnome-terminal
    gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar "false"
    gsettings set org.gnome.Terminal.Legacy.Settings mnemonics-enabled "false"

    local PROFILE=($(dconf list /org/gnome/terminal/legacy/profiles:/ | grep '^:'))
    if (( "${#PROFILE}" == 0 )); then
        echo "no profiles found"
        return
    fi

    echo "configuring for ${PROFILE[0]}"
    dconf write /org/gnome/terminal/legacy/profiles:/${PROFILE}background-color "'rgb(0,0,0)'"
    dconf write /org/gnome/terminal/legacy/profiles:/${PROFILE}use-theme-colors "false"
    dconf write /org/gnome/terminal/legacy/profiles:/${PROFILE}foreground-color "'rgb(255,255,255)'"
}


function gnome-privacy-conf {
    dconf write /org/gnome/desktop/privacy/remember-recent-files "false"
    dconf write /org/gnome/desktop/privacy/send-software-usage-stats "false"
    dconf write /org/gnome/desktop/privacy/recent-files-max-age "0"
    dconf write /org/gnome/system/location/enabled "false"
    rm ~/.local/share/recently-used.xbel
}


function gnome-desktop-conf {
    dconf write /org/gnome/desktop/background/show-desktop-icons "false"
}


if [[ $(basename "$0") == "main.sh" ]]; then
    gnome-terminal-conf
    gnome-privary-conf
    gnome-desktop-conf
fi
