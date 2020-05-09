#!/usr/bin/bash

FILE=/usr/local/bin/chromium
cat > $FILE <<EOF
exec /usr/bin/chromium --incognito $@
EOF
chmod +x $FILE

FILE=/usr/local/bin/gitg
cat > $FILE <<EOF
GTK_THEME=Adwaita:light exec /usr/bin/gitg $@
EOF
chmod +x $FILE

FILE=/usr/local/bin/xflock4
cat > $FILE <<EOF
xfce4-screensaver-command -l
EOF
chmod +x $FILE
