$(eval $(call INIT_MODULE))

obj-y += foo.o
obj-y += foo2.o
obj-y += usersub1/
obj-y += usersub2/

CFLAGS_REMOVE_foo.o = -O1
CFLAGS_foo.o = -g -O0

$(eval $(call END_MODULE))
