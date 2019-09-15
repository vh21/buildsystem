obj-y += foo.o
obj-y += foo2.o

CFLAGS_REMOVE_foo.o = -O1
CFLAGS_foo.o = -g -O0

