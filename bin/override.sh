#!/usr/bin/bash


FILE=/usr/local/bin/gitg
cat > $FILE <<EOF
GTK_THEME=Adwaita:light exec /usr/bin/gitg "\$@"
EOF
chmod +x $FILE
