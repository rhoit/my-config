all: patch

link: conf
	./install.sh linky

install: conf
	./install.sh

clean:
	rm -f conf

patch: # patch for ubuntu
	@[ -e /usr/share/git/git-prompt.sh ] && cp /tmp/git-prompt.sh /opt/

uninstall:
	rm -f ~/.bashrc
	rm -f ~/.shellrc
	rm -f ~/.shellrc.d
	rm -f ~/.zshrc

unlink: uninstall

#restore:
