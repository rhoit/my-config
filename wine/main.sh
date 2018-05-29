#!/usr/bin/env bash

# https://wiki.archlinux.org/index.php/wine
rm ~/.local/share/mime/packages/x-wine*
rm ~/.local/share/applications/wine-extension*
rm ~/.local/share/icons/hicolor/*/*/application-x-wine-extension*
rm ~/.local/share/mime/application/x-wine-extension*

WINEARCH=win32 WINEPREFIX=~/.wine winecfg

wine_path=~/.local/share/applications/wine
menu=~/.config/menus/applications-merged

cat > $wine_path/wine-browsedrive.desktop <<EOF
[Desktop Entry]
Name=Browse C: Drive
Comment=Browse your virtual C: drive
Exec=wine winebrowser c:
Terminal=false
Type=Application
Icon=folder-wine
Categories=Wine;
EOF


cat > $wine_path/wine-uninstaller.desktop <<EOF
[Desktop Entry]
Name=Uninstall Wine Software
Comment=Uninstall Windows applications for Wine
Exec=wine uninstaller
Terminal=false
Type=Application
Icon=wine-uninstaller
Categories=Wine;
EOF

cat > $wine_path/wine-winecfg.desktop <<EOF
[Desktop Entry]
Name=Configure Wine
Comment=Change application-specific and general Wine options
Exec=winecfg
Terminal=false
Icon=wine-winecfg
Type=Application
Categories=Wine;
EOF

cat > $menu/wine.menu <<EOF
<!DOCTYPE Menu PUBLIC "-//freedesktop//DTD Menu 1.0//EN"
"http://www.freedesktop.org/standards/menu-spec/menu-1.0.dtd">
<Menu>
  <Name>Applications</Name>
  <Menu>
    <Name>wine-wine</Name>
    <Directory>wine-wine.directory</Directory>
    <Include>
      <Category>Wine</Category>
    </Include>
  </Menu>
</Menu>
EOF
