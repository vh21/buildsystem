# Copyright (c) 2013 The F9 Microkernel Project. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
objs := $(all-y)
deps := $(objs:%.o=%.o.d)
build-utils := $(foreach u,$(build-util-bin),$(out)/util/$(u))
host-utils := $(foreach u,$(host-util-bin),$(out)/util/$(u))

#
# temp variables
#
objname = $(basename $(notdir $@))
tmpcflags = $(CFLAGS_TOOLCHAIN) $(CFLAGS_$(objname).o)
CFLAGS = $(filter-out $(CFLAGS_REMOVE_$(objname).o), $(tmpcflags))

#
# Create output directories if necessary
#
_dir_create := $(foreach d,$(dirs),$(shell [ -d $(out)/$(d) ] || \
	    mkdir -p $(out)/$(d)))
_dir_y_create := $(foreach d,$(dirs-y),$(shell [ -d $(out)/$(d) ] || \
	    mkdir -p $(out)/$(d)))

bin-list = $(bin-list-y)

#
# makefile targets
#
.PHONY: all
all: $(out)/$(BOARD).elf

$(out)/%.bin: $(out)/%.elf.bin $(bin-list)
	$(call quiet,bin,CAT    )

$(out)/%.elf.bin: $(out)/%.elf
	$(call quiet,obj_to_bin,OBJCOPY)

$(out)/%.list: $(out)/%.elf
	$(call quiet,elf_to_list,OBJDUMP)

$(out)/$(BOARD).elf: $(objs)
	$(call quiet,elf,LD     )

$(out)/%.o:%.c
	$(call quiet,c_to_o,CC     )

$(out)/%.o:%.S
	$(call quiet,c_to_o,AS     )

$(build-utils): $(out)/%:%.c
	$(call quiet,c_to_build,BUILDCC)

.PHONY: clean
clean:
	-rm -rf $(out)

.PHONY: distclean
distclean: clean
	-rm -rf $(out_host)
	-rm -f $(CONFIG) $(CONFIG).old include/autoconf.h

$(out_host)/mconf:
	$(call quiet,kconfig_prepare,PREPARE)
	$(call quiet,kconfig,CONFIG )

config: $(out_host)/mconf
	$(call quiet,mconf,EVAL   )

.SECONDARY:

-include $(deps)
