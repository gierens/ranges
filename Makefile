CC=gcc
CFLAGS=-O3 -Wall -Wextra -Werror -Wpedantic -Wformat=2 -Wformat-overflow=2 -Wformat-truncation=2 -Wformat-security -Wnull-dereference -Wstack-protector -Wtrampolines -Walloca -Wvla -Warray-bounds=2 -Wimplicit-fallthrough=3 -Wtraditional-conversion -Wshift-overflow=2 -Wcast-qual -Wstringop-overflow=4 -Wconversion -Warith-conversion -Wlogical-op -Wduplicated-cond -Wduplicated-branches -Wformat-signedness -Wshadow -Wstrict-overflow=4 -Wundef -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wstack-usage=1000000 -Wcast-align=strict -D_FORTIFY_SOURCE=2 -fstack-protector-strong -fstack-clash-protection -fPIE -Wl,-z,relro -Wl,-z,now -Wl,-z,noexecstack -Wl,-z,separate-code
# -fsanitize=address -fsanitize=pointer-compare -fsanitize=pointer-subtract -fsanitize=leak -fno-omit-frame-pointer -fsanitize=undefined -fsanitize=bounds-strict -fsanitize=float-divide-by-zero -fsanitize=float-cast-overflow -fanalyzer
# ASAN_OPTIONS=strict_string_checks=1:detect_stack_use_after_return=1:check_initialization_order=1:strict_init_order=1:detect_invalid_pointer_pairs=2
DESTDIR=/usr/bin
DOCDIR=/usr/share/man/man1
NAME=ranges
VERSION=0.1
ARCH=amd64

BINARY=bin/ranges
MANPAGE=docs/ranges.1.gz

DEB_TMP_DIR=$(NAME)_$(VERSION)_$(ARCH)
DEB_PACKAGE=$(NAME)_$(VERSION)_$(ARCH).deb
define DEB_CONTROL
Package: $(NAME)
Version: $(VERSION)
Section: utils
Priority: optional
Architecture: $(ARCH)
Depends:
Maintainer: Sandro-Alessio Gierens <sandro@gierens.de>
Description: Command line program to extract ranges from the inputted list.
 ranges is a command line program written in C that extracts ranges from
 various types of lists. By default it parses signed decimal integer lists,
 but given the right argument it can work with unsigned hexadecimal, octal
 and binary numbers, dates, IPv4, IPv6 and MAC addresses. The list input
 is given over the standard input, so by pipe, and is assumed to be sorted,
 but can have duplicates.
endef
export DEB_CONTROL


.PHONY: bin
bin: $(BINARY)

bin/%: src/%.c
	# $(ASAN_OPTIONS) $(CC) $(CFLAGS) $< -o $@
	$(CC) $(CFLAGS) $< -o $@

.PHONY: setup
setup:
	git submodule init
	git submodule update

.PHONY: tests
tests: all
	test/deps/bats/bin/bats -j `nproc` test/*.bats

.PHONY: docs
docs: $(MANPAGE)

docs/%.gz: docs/%
	gzip -c $< > $@

docs/%: docs/%.md
	pandoc $< -s -t man -o $@

.PHONY: install
install: $(BINARY) $(MANPAGE)
	install -d $(DESTDIR)
	install -m 755 $(BINARY) $(DESTDIR)
	install -m 644 $(MANPAGE) $(DOCDIR)
	mandb --quiet

.PHONY: uninstall
uninstall:
	rm -f $(DESTDIR)/ranges
	rm -f $(DOCDIR)/ranges.1.gz
	mandb --quiet

.PHONY: deb
deb: $(DEB_PACKAGE)
$(DEB_PACKAGE): $(BINARY) $(MANPAGE)
	# create temporary build directory
	mkdir -p $(DEB_TMP_DIR)
	# binary
	mkdir -p $(DEB_TMP_DIR)$(DESTDIR)
	cp bin/ranges $(DEB_TMP_DIR)$(DESTDIR)
	# man page
	mkdir -p $(DEB_TMP_DIR)$(DOCDIR)
	cp docs/ranges.1.gz $(DEB_TMP_DIR)$(DOCDIR)
	# control file
	mkdir -p $(DEB_TMP_DIR)/DEBIAN
	touch $(DEB_TMP_DIR)/DEBIAN/control
	@echo "$$DEB_CONTROL" > $(DEB_TMP_DIR)/DEBIAN/control
	# build package
	dpkg-deb --build --root-owner-group $(DEB_TMP_DIR)
	# clean up
	rm -rf $(DEB_TMP_DIR)

.PHONY: clean
clean:
	rm -f bin/*
	rm -f docs/*.1 docs/*.1.gz
	rm -f $(DEB_PACKAGE)

