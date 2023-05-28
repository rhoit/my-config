#!/usr/bin/bash


FILE=/usr/local/bin/chromium
cat > $FILE <<EOF
exec /usr/bin/chromium --incognito --allow-file-access-from-file "\$@"
EOF
chmod +x $FILE


FILE=/usr/local/bin/emacs
cat > $FILE <<EOF
LSP_USE_PLISTS=true exec /usr/bin/emacs "\$@"
EOF
chmod +x $FILE


FILE=/usr/local/bin/gitg
cat > $FILE <<EOF
GTK_THEME=Adwaita:light exec /usr/bin/gitg "\$@"
EOF
chmod +x $FILE
