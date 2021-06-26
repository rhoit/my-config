#!/usr/bin/bash

FILE=/usr/local/bin/fix-xfce4-terminal
cat > $FILE <<EOF
xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Primary><Alt>t' --create --verbose --type string --set "xfce4-terminals"
xfconf-query -c xfce4-keyboard-shortcuts -p '/commands/custom/<Primary><Alt>t' --create --verbose --type string --set "xfce4-terminal"
EOF
chmod +x $FILE
echo $FILE installed
