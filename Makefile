CC=gcc
CFLAGS=-O3 -Wall -Werror
DESTDIR=/usr/bin

.PHONY: all
all: bin/ranges

bin/%: src/%.c
	$(CC) $(CFLAGS) $< -o $@

.PHONY: setup
setup:
	git submodule init
	git submodule update

.PHONY: tests
tests: all
	test/deps/bats/bin/bats test/*.bats

.PHONY: clean
clean:
	rm -f bin/*

.PHONY: install
install: all
	install -d $(DESTDIR)
	install -m 755 bin/ranges $(DESTDIR)
	ln -s $(DESTDIR)/ranges $(DESTDIR)/rn

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)/ranges
	rm -f $(DESTDIR)/rn
