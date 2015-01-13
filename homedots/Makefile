all:
	@[ -e conf ] && echo -e "All set\nrun 'make [install|link]'" || echo "run './configure' first"

link: conf
	./install.sh linky

install: conf
	./install.sh

clean:
	rm -f conf installed

uninstall-everything:
	CHECK=0 ./configure
	sed -i 's/^/~\/./' conf
	rm -f < conf
	rm conf

uninstall: installed
	rm -f < installed

reinstall: uninstall install

unlink: uninstall
