
# Toolchain configuration
CROSS_COMPILE ?= 
HOST_COMPILE ?=

CC = $(CROSS_COMPILE)gcc
CPP = $(CROSS_COMPILE)cpp
LD = $(CROSS_COMPILE)gcc
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump
NM = $(CROSS_COMPILE)nm

BUILDCC = $(HOST_COMPILE)gcc

# Misc Information
GIT_HEAD = $(shell git rev-parse HEAD)
MACH_TYPE = $(shell uname -m)
BUILD_TIME = $(shell date --iso=seconds)

CFLAGS_WARN = \
	-Wall -Werror -Wundef -Wstrict-prototypes -Wno-trigraphs	\
	-fno-strict-aliasing -fno-common				\
	-Werror-implicit-function-declaration -Wno-format-security	\
	-fno-delete-null-pointer-checks -Wdeclaration-after-statement	\
	-Wno-pointer-sign -fno-strict-overflow -fconserve-stack
CFLAGS_OPT = -O1 -fno-toplevel-reorder
CFLAGS_DEBUG = -g3
CFLAGS_INCLUDE = $(foreach i,$(includes),-I$(i) )
CFLAGS_DEFINE = \
	-D __BOARD__=$(BOARD) \
	-D'INC_PLAT(x)=<platform/__PLATFORM__/x>'

CFLAGS_MISC_DEFINE = \
	-DGIT_HEAD=\"$(GIT_HEAD)\" \
	-DMACH_TYPE=\"$(MACH_TYPE)\" \
	-DBUILD_TIME=\"$(BUILD_TIME)\"

CPPFLAGS_TOOLCHAIN = \
	$(CFLAGS_DEFINE) $(CFLAGS_INCLUDE) $(EXTRA_CFLAGS)

CFLAGS_TOOLCHAIN = \
	-std=gnu99 -isystem \
	-ffreestanding \
	$(CPPFLAGS_TOOLCHAIN) $(CFLAGS_CPU) $(CFLAGS_OPT) $(CFLAGS_DEBUG) $(CFLAGS_WARN) $(CFLAGS_y) $(CFLAGS_MISC_DEFINE)

LIBGCC = $(shell $(CC) -print-libgcc-file-name)
