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

