The project is released under 2-clause BSD license

----
The source of kconfig comes from linux and it's under GPL license

----
kbuild type building environment. Inspired by F9 Microkernel, linux kernel

Characteristics:
  1. Support linux kernel menuconfig

  2. Use 'obj-$(CONFIG\_FOO) = foo.o' to add foo.o to compiling list  when
     CONFIG\_FOO is defined

  3. Use 'CFLAGS\_foo.o = xxxx' to specific compiling flags for foo.o.
     Use 'CFLAGS\_REMOVE\_foo.o = xxxx' to remove some flags from default CFLAGS
     when compiling foo.o

