savedcmd_arch/x86/tools/relocs_32.o := gcc -Wp,-MMD,arch/x86/tools/.relocs_32.o.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer -std=gnu11   -I/home/jacob/contest/linux-6.6.1/tools/include  -I ./arch/x86/tools -c -o arch/x86/tools/relocs_32.o /home/jacob/contest/linux-6.6.1/arch/x86/tools/relocs_32.c

source_arch/x86/tools/relocs_32.o := /home/jacob/contest/linux-6.6.1/arch/x86/tools/relocs_32.c

deps_arch/x86/tools/relocs_32.o := \
  /home/jacob/contest/linux-6.6.1/arch/x86/tools/relocs.h \
  /home/jacob/contest/linux-6.6.1/tools/include/tools/le_byteshift.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/tools/relocs.c \
    $(wildcard include/config/FW_LOADER) \

arch/x86/tools/relocs_32.o: $(deps_arch/x86/tools/relocs_32.o)

$(deps_arch/x86/tools/relocs_32.o):
