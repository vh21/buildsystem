user-y += foo.o
user-y += foo2.o

CFLAGS_REMOVE_foo.o = -O1
CFLAGS_foo.o = -g -O0

