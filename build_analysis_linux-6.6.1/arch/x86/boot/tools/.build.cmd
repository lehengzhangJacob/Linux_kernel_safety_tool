savedcmd_arch/x86/boot/tools/build := gcc -Wp,-MMD,arch/x86/boot/tools/.build.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer -std=gnu11   -I/home/jacob/contest/linux-6.6.1/tools/include -include include/generated/autoconf.h -D__EXPORTED_HEADERS__  -I ./arch/x86/boot   -o arch/x86/boot/tools/build /home/jacob/contest/linux-6.6.1/arch/x86/boot/tools/build.c   

source_arch/x86/boot/tools/build := /home/jacob/contest/linux-6.6.1/arch/x86/boot/tools/build.c

deps_arch/x86/boot/tools/build := \
    $(wildcard include/config/EFI_MIXED) \
    $(wildcard include/config/EFI_STUB) \
    $(wildcard include/config/X86_32) \
    $(wildcard include/config/PHYSICAL_ALIGN) \
    $(wildcard include/config/EFI_HANDOVER_PROTOCOL) \
    $(wildcard include/config/X86_64) \
  /home/jacob/contest/linux-6.6.1/tools/include/tools/le_byteshift.h \

arch/x86/boot/tools/build: $(deps_arch/x86/boot/tools/build)

$(deps_arch/x86/boot/tools/build):
