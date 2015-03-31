src := .
srctree := .
obj := ./

quiet-command = $(if $(V),$1,$(if $(2),@echo $2 && $1, @$1))
Q:=@

include Makefile

.PHONY: default
default: mconf
hostprogs-y += mconf

__hostprogs := $(sort $(hostprogs-y) $(hostprogs-m))
host-csingle := $(foreach m,$(__hostprogs),$(if $($(m)-objs),,$(m)))
host-cmulti := $(foreach m,$(__hostprogs),\
           $(if $($(m)-cxxobjs),,$(if $($(m)-objs),$(m))))
host-cxxmulti := $(foreach m,$(__hostprogs),\
           $(if $($(m)-cxxobjs),$(m),$(if $($(m)-objs),)))
host-cobjs := $(addprefix $(obj)/,$(sort $(foreach m,$(__hostprogs),$($(m)-objs))))
host-cxxobjs := $(addprefix $(obj)/,$(sort $(foreach m,$(__hostprogs),$($(m)-cxxobjs))))

HOST_EXTRACFLAGS += -I$(obj)

$(host-csingle): %: %.c
	$(call quiet-command,$(HOSTCC) $(HOST_EXTRACFLAGS) $(HOSTCFLAGS) $(HOSTCFLAGS_$@) $< -o $(obj)/$@)

$(host-cmulti): %: $(host-cobjs) $(host-cshlib)
	$(call quiet-command,$(HOSTCC) $(HOST_EXTRACFLAGS) $(HOSTCFLAGS) $(HOSTCFLAGS_$@) $(addprefix $(obj)/,$($(@F)-objs)) $(HOSTLOADLIBES_$(@F)) -o $(obj)/$@)

$(host-cxxmulti): %: $(host-cxxobjs) $(host-cobjs) $(host-cshlib)
	$(call quiet-command,$(HOSTCXX) $(HOST_EXTRACFLAGS) $(HOSTCFLAGS) $(HOSTCXXFLAGS_$@) $(addprefix $(obj)/,$($(@F)-objs) $($(@F)-cxxobjs)) $(HOSTLOADLIBES_$(@F)) -o $(obj)/$@)

$(obj)/%.o: %.c
	$(call quiet-command,$(HOSTCC) $(HOST_EXTRACFLAGS) $(HOSTCFLAGS) $(HOSTCFLAGS_$(@F)) -c $< -o $@)

$(obj)/%.o: $(obj)/%.c
	$(call quiet-command,$(HOSTCC) $(HOST_EXTRACFLAGS) $(HOSTCFLAGS) $(HOSTCFLAGS_$(@F)) -c $< -o $@)

$(obj)/%.o: %.cc
	$(call quiet-command,$(HOSTCC) $(HOST_EXTRACFLAGS) $(HOSTCFLAGS) $(HOSTCXXFLAGS_$(@F)) -c $< -o $@)

$(obj)/%:: $(src)/%_shipped
	$(call quiet-command,cat $< > $@)

clean:
	$(call quiet-command,rm -f $(addprefix $(obj)/,$(clean-files)))
distclean: clean
	$(call quiet-command,rm -f $(addprefix $(obj)/,$(lxdialog) $(conf-objs) $(mconf-objs) $(kxgettext-objs) \
		$(hostprogs-y) $(qconf-cxxobjs) $(qconf-objs) $(gconf-objs) \
		mconf .depend))

FORCE:
.PHONY: FORCE clean distclean
.SECONDARY:
