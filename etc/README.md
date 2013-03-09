# etc

These are the some of the configuration notes.

## Disable Clearing of Boot Messages
`source: [Arch Wiki][1]`

After the boot process, the screen is cleared and the login prompt appears, leaving users unable to read init output and error messages. This is how to mae  boot messages stay on tty1. 

	# sed /TTYVTDisallocate=/s/yes/no/ < /usr/lib/systemd/system/getty@.service > /etc/systemd/system/getty.target.wants/getty@tty1.service


[1]: https://wiki.archlinux.org/index.php/Disable_Clearing_of_Boot_Mess
