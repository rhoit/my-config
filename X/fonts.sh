#!/usr/bin/bash

# pacman -S extra/xorg-xlsfonts  # List available X fonts
# pacman -S extra/xorg-mkfontscale  # Create an index of scalable font files for X

FILE='/etc/X11/xorg.conf.d/30-fonts.conf'

> $FILE echo 'Section "Files"'
for path in /usr/share/fonts/* ; do
    >> $FILE echo "    FontPath    \"$path\""
done
>> $FILE echo 'EndSection'
