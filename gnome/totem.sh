#!/bin/bash

# make queue
sed -i 's/\(Exec=\).*/\1totem --enqueue %U/' /usr/share/applications/totem.desktop
