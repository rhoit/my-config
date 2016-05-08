sysctl:
	echo "fs.inotify.max_user_watches = 100000" > /etc/sysctl.d/90-inotify.conf

share-home:
	mkdir -p /etc/systemd/system/minidlna.service.d/
	echo -e "[Service]\nProtectHome=read-only" > /etc/systemd/system/minidlna.service.d/override.conf
