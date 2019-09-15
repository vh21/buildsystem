$(eval $(call INIT_MODULE))
obj-y += foo3.o
obj-y += usersub11/

CFLAGS_REMOVE_foo3.o = -O1
CFLAGS_foo3.o = -g -O0

$(eval $(call END_MODULE))
