# Copyright (c) 2013 The F9 Microkernel Project. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# Toolchain configuration
CROSS_COMPILE ?= arm-none-eabi-
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
	-fno-common -Werror-implicit-function-declaration		\
	-Wdeclaration-after-statement -fconserve-stack

CFLAGS_OPT = -O1
CFLAGS_DEBUG = -g3
CFLAGS_INCLUDE = $(foreach i,$(includes),-I$(i) )
CFLAGS_DEFINE = \
	-D __PLATFORM__=$(CHIP) \
	-D __BOARD__=$(BOARD) \
	-D'INC_PLAT(x)=<platform/__PLATFORM__/x>'

CFLAGS_MISC_DEFINE = \
	-DGIT_HEAD=\"$(GIT_HEAD)\" \
	-DMACH_TYPE=\"$(MACH_TYPE)\" \
	-DBUILD_TIME=\"$(BUILD_TIME)\"
CPPFLAGS_TOOLCHAIN  = \
	$(CFLAGS_DEFINE) $(CFLAGS_INCLUDE) $(EXTRA_CFLAGS)

CFLAGS_TOOLCHAIN = \
	-std=gnu99 -isystem \
	-nostdlib -ffreestanding \
	$(CPPFLAGS_TOOLCHAIN) $(CFLAGS_CPU) $(CFLAGS_OPT) $(CFLAGS_DEBUG) $(CFLAGS_WARN) $(CFLAGS_y) $(CFLAGS_MISC_DEFINE)

LIBGCC = $(shell $(CC) -print-libgcc-file-name)
