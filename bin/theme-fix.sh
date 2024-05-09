#!/usr/bin/bash

set -e

BIN="${1}"; test -n "$BIN"
THEME="${2:-Adwaita:dark}"

PATH_bin="$(which "$BIN")"
PATH_bin_local="/usr/local/bin/$BIN"

if [[ "$PATH_bin" == "$PATH_bin_local" ]]; then
    echo "$PATH_bin is already overridden"
    exit
fi

cat > "$PATH_bin_local" <<EOF
GTK_THEME=$THEME exec $PATH_bin "\$@"
EOF
chmod +x "$PATH_bin_local"
