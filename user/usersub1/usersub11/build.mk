$(eval $(call INIT_MODULE))
obj-y += foo31.o

CFLAGS_REMOVE_foo31.o = -O1
CFLAGS_foo31.o = -g -O0

$(eval $(call END_MODULE))
