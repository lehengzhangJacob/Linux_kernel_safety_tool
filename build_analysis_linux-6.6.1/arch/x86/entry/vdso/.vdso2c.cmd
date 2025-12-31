savedcmd_arch/x86/entry/vdso/vdso2c := gcc -Wp,-MMD,arch/x86/entry/vdso/.vdso2c.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer -std=gnu11   -I/home/jacob/contest/linux-6.6.1/tools/include -I/home/jacob/contest/linux-6.6.1/include/uapi -I/home/jacob/contest/linux-6.6.1/arch//include/uapi  -I ./arch/x86/entry/vdso   -o arch/x86/entry/vdso/vdso2c /home/jacob/contest/linux-6.6.1/arch/x86/entry/vdso/vdso2c.c   

source_arch/x86/entry/vdso/vdso2c := /home/jacob/contest/linux-6.6.1/arch/x86/entry/vdso/vdso2c.c

deps_arch/x86/entry/vdso/vdso2c := \
  /home/jacob/contest/linux-6.6.1/tools/include/tools/le_byteshift.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/elf.h \
  /home/jacob/contest/linux-6.6.1/tools/include/linux/types.h \
    $(wildcard include/config/PHYS_ADDR_T_64BIT) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/elf-em.h \
  /home/jacob/contest/linux-6.6.1/tools/include/linux/kernel.h \
  /home/jacob/contest/linux-6.6.1/tools/include/linux/build_bug.h \
  /home/jacob/contest/linux-6.6.1/tools/include/linux/compiler.h \
  /home/jacob/contest/linux-6.6.1/tools/include/linux/compiler_types.h \
  /home/jacob/contest/linux-6.6.1/tools/include/linux/compiler-gcc.h \
  /home/jacob/contest/linux-6.6.1/tools/include/linux/math.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/entry/vdso/vdso2c.h \

arch/x86/entry/vdso/vdso2c: $(deps_arch/x86/entry/vdso/vdso2c)

$(deps_arch/x86/entry/vdso/vdso2c):
