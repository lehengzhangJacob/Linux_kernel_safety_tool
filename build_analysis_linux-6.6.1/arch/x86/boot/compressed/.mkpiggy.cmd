savedcmd_arch/x86/boot/compressed/mkpiggy := gcc -Wp,-MMD,arch/x86/boot/compressed/.mkpiggy.d -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 -fomit-frame-pointer -std=gnu11   -I/home/jacob/contest/linux-6.6.1/tools/include  -I ./arch/x86/boot/compressed   -o arch/x86/boot/compressed/mkpiggy /home/jacob/contest/linux-6.6.1/arch/x86/boot/compressed/mkpiggy.c   

source_arch/x86/boot/compressed/mkpiggy := /home/jacob/contest/linux-6.6.1/arch/x86/boot/compressed/mkpiggy.c

deps_arch/x86/boot/compressed/mkpiggy := \
  /home/jacob/contest/linux-6.6.1/tools/include/tools/le_byteshift.h \

arch/x86/boot/compressed/mkpiggy: $(deps_arch/x86/boot/compressed/mkpiggy)

$(deps_arch/x86/boot/compressed/mkpiggy):
