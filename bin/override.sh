#!/usr/bin/bash

set -e
set -v


# --incognito PRIVACY MODE
# --disable-web-security DISABLE CORS
# --user-data-dir REQUIRED FOR --disable-web-security
# --allow-file-access-from-file
FILE=/usr/local/bin/chromium
cat > $FILE <<EOF
exec /usr/bin/chromium --incognito --user-data-dir=\$(mktemp) --disable-web-security --allow-file-access-from-file "\$@"
EOF
chmod +x $FILE


FILE=/usr/local/bin/gitg
cat > $FILE <<EOF
GTK_THEME=Adwaita:light exec /usr/bin/gitg "\$@"
EOF
chmod +x $FILE
