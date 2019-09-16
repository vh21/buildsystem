#
# Initialization of a subdirectories makefile. Mainly clean up variables
#
define INIT_MODULE
    # Clean up local variables
    obj-y :=
    _mkpath := $$(lastword $$(MAKEFILE_LIST))
endef

#
# Post processing of a subdirectories makefile. Mainly update global variables
# then include subdirectories
#
define END_MODULE
    # Manipulate local variables
    _curdir := $$(dir $$(_mkpath))
    _obj-y := $$(addprefix $$(out)/$$(_curdir), $$(filter-out %/, $$(obj-y)))
    _subdir-y := $$(addprefix $$(_curdir), $$(filter %/, $$(obj-y)))

    # Update global variables
    all-y += $$(_obj-y)
    dirs-y += $$(_subdir-y)

    # Go on parsing sub-directories if exists
    -include $$(addsuffix build.mk, $$(_subdir-y))
endef

#
# Decrease verbosity unless you pass V=1
#
quiet = $(if $(V),,@echo '  $(2)' $(subst $(out)/,,$@) ; )$(cmd_$(1))
silent = $(if $(V),,1>/dev/null)

#
# commands to build all targets
#
cmd_obj_to_bin = $(OBJCOPY) -O binary $< $@
cmd_elf_to_list = $(OBJDUMP) -S $< > $@
cmd_elf = $(LD) $(LDFLAGS) $(objs) -o $@ \
	 $(LIBGCC) \
	-Wl,-Map,$(out)/$*.map
cmd_c_to_o = $(CC) $(CFLAGS) -MMD -MF $@.d -c $< -o $@
cmd_c_to_build = $(BUILDCC) $(BUILD_CFLAGS) $(BUILD_LDFLAGS) \
	         -MMD -MF $@.d $< -o $@
cmd_bin = cat $^ > $@

#
# commands to build Kconfig
#
KCONFIG := utils/kconfig
cmd_kconfig_prepare = mkdir -p $(out_host) $(out_host)/lxdialog
cmd_kconfig = $(MAKE) --no-print-directory -C $(KCONFIG) -f main.mk default \
		obj=$(shell pwd)/$(out_host) \
		CC="$(BUILDCC)" HOSTCC="$(BUILDCC)"
cmd_mconf = $< Kconfig
