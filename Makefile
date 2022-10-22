CC=gcc
CFLAGS=-O3

.PHONY: all
all: bin/ranges

bin/%: src/%.c
	$(CC) $(CFLAGS) $< -o $@	

.PHONY: setup
setup:
	git submodule init

.PHONY: tests
tests: all
	test/deps/bats/bin/bats test/*.bats

.PHONY: clean
clean:
	rm -f *.out
