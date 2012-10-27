#!/bin/bash

xdg_menu --format openbox3 --fullmenu > test #> .config/openbox/menu.xml
line=`grep -n '<menu id="root-menu"' test | cut -d':' -f1`
echo "sed '$line""d; $(($line - 1))d' test -i" > /tmp/sedfile
bash /tmp/sedfile
sed '/<menu id="xdg"/a<menu id="root-menu" label="Openbox 3">' test -i
sed '/<\/openbox_menu>/i</menu>' test -i

# 
#echo " '/<menu id="KDE Menu"/d

mv test menu.xml
openbox --reconfigure


