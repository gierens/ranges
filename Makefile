CC=gcc
CFLAGS=-O3 -Wall -Wextra -Werror
DESTDIR=/usr/bin
DOCDIR=/usr/share/man/man1

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
	test/deps/bats/bin/bats -j `nproc` test/*.bats

.PHONY: clean
clean:
	rm -f bin/*
	rm -f docs/*.1 docs/*.1.gz

.PHONY: docs
docs: docs/ranges.1.gz

docs/%.gz: docs/%
	gzip -c $< > $@

docs/%: docs/%.md
	pandoc $< -s -t man -o $@

.PHONY: install
install: all docs
	install -d $(DESTDIR)
	install -m 755 bin/ranges $(DESTDIR)
	install -m 644 docs/ranges.1.gz $(DOCDIR)
	mandb --quiet

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)/ranges
	rm -f $(DOCDIR)/ranges.1.gz
	mandb --quiet
