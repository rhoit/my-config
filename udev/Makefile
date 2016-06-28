install-android:
	install -m 644 51-android.rules -t /etc/udev/rules.d/
	udevadm control --reload

install-hide-partition:
	install -m 644 90-hide-partitions.rules -t /etc/udev/rules.d/
	udevadm control --reload
