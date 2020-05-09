#!/usr/bin/bash

set -e
set -v


FILE=/usr/local/bin/gitg
cat > $FILE <<EOF
GTK_THEME=Adwaita:light exec /usr/bin/gitg "\$@"
EOF
chmod +x $FILE
