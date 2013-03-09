To fix that, just disable bitmap fonts for X:

$ sudo ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/

[link]: https://wiki.archlinux.org/index.php/Firefox#Firefox_uses_ugly_fonts_for_its_interface
