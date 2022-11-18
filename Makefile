CC=gcc-11
CFLAGS=-O3 -Wall -Wextra -Werror -Wpedantic -Wformat=2 -Wformat-overflow=2 -Wformat-truncation=2 -Wformat-security -Wnull-dereference -Wstack-protector -Wtrampolines -Walloca -Wvla -Warray-bounds=2 -Wimplicit-fallthrough=3 -Wtraditional-conversion -Wshift-overflow=2 -Wcast-qual -Wstringop-overflow=4 -Wconversion -Warith-conversion -Wlogical-op -Wduplicated-cond -Wduplicated-branches -Wformat-signedness -Wshadow -Wstrict-overflow=4 -Wundef -Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wstack-usage=1000000 -Wcast-align=strict -D_FORTIFY_SOURCE=2 -fstack-protector-strong -fstack-clash-protection -fPIE -Wl,-z,relro -Wl,-z,now -Wl,-z,noexecstack -Wl,-z,separate-code
# -fsanitize=address -fsanitize=pointer-compare -fsanitize=pointer-subtract -fsanitize=leak -fno-omit-frame-pointer -fsanitize=undefined -fsanitize=bounds-strict -fsanitize=float-divide-by-zero -fsanitize=float-cast-overflow -fanalyzer
# ASAN_OPTIONS=strict_string_checks=1:detect_stack_use_after_return=1:check_initialization_order=1:strict_init_order=1:detect_invalid_pointer_pairs=2
DESTDIR=/usr/bin
DOCDIR=/usr/share/man/man1
NAME=ranges
VERSION=1.0.0
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
Depends: libc6
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

define DEB_COPYRIGHT
Format: http://www.debian.org/doc/packaging-manuals/copyright-format/1.0/
Upstream-Name: $(NAME)
Upstream-Contact: Sandro-Alessio Gierens <sandro@gierens.de>
Source: https://github.com/gierens/ranges/releases

Files: *
License: GPL-3+
Copyright: 2022 Sandro-Alessio Gierens <sandro@gierens.de>

Files: debian/*
License: GPL-3+
Copyright: 2022 Sandro-Alessio Gierens <sandro@gierens.de>

License: GPL-3+
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 3 of the License, or
 (at your option) any later version.
 .
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU General Public License for more details.
 .
 You should have received a copy of the GNU General Public License along
 with this program; if not, write to the Free Software Foundation, Inc.,
 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 .
 On Debian systems, the full text of the GNU General Public
 License version 3 can be found in the file
 `/usr/share/common-licenses/GPL-3'.
endef
export DEB_COPYRIGHT


.PHONY: bin
bin: $(BINARY)

bin/%: src/%.c
	# $(ASAN_OPTIONS) $(CC) $(CFLAGS) $< -o $@
	$(CC) $(CFLAGS) -DVERSION=\"$(VERSION)\" $< -o $@
	strip --strip-unneeded --remove-section=.comment --remove-section=.note $@

.PHONY: setup
setup:
	git submodule init
	git submodule update

.PHONY: tests
tests: $(BINARY)
	test/deps/bats/bin/bats -j `nproc` test/*.bats

.PHONY: docs
docs: $(MANPAGE)

docs/%.gz: docs/%
	gzip -cn9 $< > $@

docs/%: docs/%.md
	bash -c "pandoc <(sed 's/{{ VERSION }}/$(VERSION)/g' $<) -s -f markdown -t man -o $@"

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
$(DEB_PACKAGE): $(BINARY) $(MANPAGE) Makefile
	# create temporary build directory
	mkdir -p $(DEB_TMP_DIR)
	# create directory structure
	mkdir -p $(DEB_TMP_DIR)$(DESTDIR)
	mkdir -p $(DEB_TMP_DIR)$(DOCDIR)
	mkdir -p $(DEB_TMP_DIR)/DEBIAN
	mkdir -p $(DEB_TMP_DIR)/usr/share/doc/$(NAME)
	# fix directory permissions
	chmod 755 -R $(DEB_TMP_DIR)
	# binary
	cp bin/ranges $(DEB_TMP_DIR)$(DESTDIR)
	chmod 755 $(DEB_TMP_DIR)$(DESTDIR)/ranges
	# man page
	cp docs/ranges.1.gz $(DEB_TMP_DIR)$(DOCDIR)
	chmod 644 $(DEB_TMP_DIR)$(DOCDIR)/ranges.1.gz
	# control file
	touch $(DEB_TMP_DIR)/DEBIAN/control
	@echo "$$DEB_CONTROL" > $(DEB_TMP_DIR)/DEBIAN/control
	chmod 644 $(DEB_TMP_DIR)/DEBIAN/control
	# changelog
	cp CHANGELOG.md $(DEB_TMP_DIR)/usr/share/doc/$(NAME)/changelog
	gzip -cn9 $(DEB_TMP_DIR)/usr/share/doc/$(NAME)/changelog > $(DEB_TMP_DIR)/usr/share/doc/$(NAME)/changelog.gz
	rm $(DEB_TMP_DIR)/usr/share/doc/$(NAME)/changelog
	chmod 644 $(DEB_TMP_DIR)/usr/share/doc/$(NAME)/changelog.gz
	# copyright file
	touch $(DEB_TMP_DIR)/usr/share/doc/$(NAME)/copyright
	@echo "$$DEB_COPYRIGHT" > $(DEB_TMP_DIR)/usr/share/doc/$(NAME)/copyright
	chmod 644 $(DEB_TMP_DIR)/usr/share/doc/$(NAME)/copyright
	# build package
	dpkg-deb --build --root-owner-group $(DEB_TMP_DIR)
	# clean up
	rm -rf $(DEB_TMP_DIR)

.PHONY: deb-tests
deb-tests: $(DEB_PACKAGE)
	lintian $(DEB_PACKAGE)

.PHONY: deb-install
deb-install: $(DEB_PACKAGE)
	sudo dpkg -i $(DEB_PACKAGE)

.PHONY: deb-uninstall
deb-uninstall:
	sudo dpkg -r $(NAME)

.PHONY: perf-comparison
perf-comparison: $(BINARY)
	./scripts/perf-comparison.sh

.PHONY: clean
clean:
	rm -f bin/*
	rm -f docs/*.1 docs/*.1.gz
	rm -f *.deb
