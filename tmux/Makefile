link:
	ln -s ${PWD}/tmux.conf ~/.tmux.conf

unlink: ~/.tmux.conf
	readlink ~/.tmux.conf && rm ~/.tmux.conf

# https://wiki.archlinux.org/index.php/tmux#Autostart_with_systemd
systemd:
	cp tmux.service /etc/systemd/system/tmux@.service
