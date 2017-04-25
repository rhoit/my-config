all: patch

link: conf
	./install.sh linky

install: conf
	./install.sh

clean:
	rm -f conf installed

patch: # patch for ubuntu
	@echo "if git-prompt is not available"
	@[ -e /usr/share/git/git-prompt.sh ] || cp /tmp/git-prompt.sh ~/

uninstall: installed
	rm -f < installed

reinstall: uninstall install

unlink: uninstall

#restore:
