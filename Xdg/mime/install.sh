#!/usr/bin/bash

# might be the local path not tested
# cp ~/.local/share/applications/mimeapps.list .

xdg-mime install ./mime/org-mode.xml
xdg-mime install ./mime/djhtml-mode.xml
xdg-mime install ./mime/scons-conf.xml

# * set default
xdg-mime default evince.desktop application/pdf

# xdg-icon-resource install --context mimetypes --size 64 shiny-file-icon.png text-x-shiny

# update mime database
# echo update-mime-database /usr/share/mime
