$(eval $(call INIT_MODULE))
obj-y += foo4.o

CFLAGS_REMOVE_foo4.o = -O1
CFLAGS_foo4.o = -g -O0

$(eval $(call END_MODULE))
