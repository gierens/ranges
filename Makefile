CC=gcc
CFLAGS=-O3

.PHONY: all
all: ranges.out

%.out: %.c
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
