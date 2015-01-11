all:
	@echo "To disable extra download"
	@echo -e "OFFLINE=1 ./configure"
	@echo "make [install|clean]"

install:
	test -e conf || echo "run the './configure' first"
	./install.sh

clean:
	rm conf

#restore:
