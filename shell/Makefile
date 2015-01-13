all: patch

link: conf
	./install.sh linky

install: conf
	./install.sh

clean:
	rm -f conf installed

patch: # patch for ubuntu
	@echo "if git-promt is not available"
	@[ -e /usr/share/git/git-prompt.sh ] || cp /tmp/git-prompt.sh /opt/

uninstall: installed
	rm -f < installed

reinstall: uninstall install

unlink: uninstall

#restore:
