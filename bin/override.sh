#!/usr/bin/bash

set -e
set -v


# --incognito PRIVACY MODE
# --disable-web-security DISABLE CORS
# --user-data-dir=\$(mktemp) REQUIRED FOR --disable-web-security
# --unsafely-disable-devtools-self-xss-warnings allow paste in devtool console
# --allow-file-access-from-file
FILE=/usr/local/bin/chromium
cat > $FILE <<EOF
exec /usr/bin/chromium --incognito --unsafely-disable-devtools-self-xss-warnings --allow-file-access-from-file "\$@"
EOF
chmod +x $FILE


FILE=/usr/local/bin/gitg
cat > $FILE <<EOF
GTK_THEME=Adwaita:light exec /usr/bin/gitg "\$@"
EOF
chmod +x $FILE
