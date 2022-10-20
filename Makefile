CC=gcc
CFLAGS=-O3

all: ranges.out

%.out: %.c
	$(CC) $(CFLAGS) $< -o $@	
