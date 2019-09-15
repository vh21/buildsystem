# Copyright (c) 2013 The F9 Microkernel Project. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

CONFIG := .config

ifneq (,$(wildcard $(CONFIG)))
include $(CONFIG)
else
all: config_error
.PHONY: config_error
config_error:
	@echo "Please ensure that it is configured by 'make config'"
	@$(MAKE) -s UNKNOWN 2>/dev/null
endif

BOARD ?= skeleton
TOOLCHAIN ?= gcc

# output directory for build objects
out ?= build/$(BOARD)

# output directory for host build boardss
out_host ?= build/host

all-y:=
dirs-y:=

include mk/utils.mk

# obtain CHIP name
include boards/$(BOARD)/build.mk

# toolchain specific configurations; common cflags and ldflags
include mk/toolchain/$(TOOLCHAIN).mk

# Transform the configuration into make variables
includes = \
	boards/$(BOARD) \
	include \
	$(dirs) $(out)
$(eval CONFIG_BOARD_$(BOARD)=y)

# Get build configuration from sub-directories
include user/build.mk

includes += $(includes-y)

# Get all sources to build
dirs = \
	boards/$(BOARD) \
	user

include mk/generic.mk
