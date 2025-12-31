savedcmd_arch/x86/entry/vdso/vdso-note.o := gcc -Wp,-MMD,arch/x86/entry/vdso/.vdso-note.o.d -nostdinc -I/home/jacob/contest/linux-6.6.1/arch/x86/include -I./arch/x86/include/generated -I/home/jacob/contest/linux-6.6.1/include -I./include -I/home/jacob/contest/linux-6.6.1/arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I/home/jacob/contest/linux-6.6.1/include/uapi -I./include/generated/uapi -include /home/jacob/contest/linux-6.6.1/include/linux/compiler-version.h -include /home/jacob/contest/linux-6.6.1/include/linux/kconfig.h -D__KERNEL__ -fmacro-prefix-map=/home/jacob/contest/linux-6.6.1/= -Werror -D__ASSEMBLY__ -fno-PIE -m64 -DBUILD_VDSO -I /home/jacob/contest/linux-6.6.1/arch/x86/entry/vdso -I ./arch/x86/entry/vdso    -c -o arch/x86/entry/vdso/vdso-note.o /home/jacob/contest/linux-6.6.1/arch/x86/entry/vdso/vdso-note.S 

source_arch/x86/entry/vdso/vdso-note.o := /home/jacob/contest/linux-6.6.1/arch/x86/entry/vdso/vdso-note.S

deps_arch/x86/entry/vdso/vdso-note.o := \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler-version.h \
    $(wildcard include/config/CC_VERSION_TEXT) \
  /home/jacob/contest/linux-6.6.1/include/linux/kconfig.h \
    $(wildcard include/config/CPU_BIG_ENDIAN) \
    $(wildcard include/config/BOOGER) \
    $(wildcard include/config/FOO) \
  /home/jacob/contest/linux-6.6.1/include/linux/build-salt.h \
    $(wildcard include/config/BUILD_SALT) \
  /home/jacob/contest/linux-6.6.1/include/linux/elfnote.h \
  /home/jacob/contest/linux-6.6.1/include/linux/uts.h \
    $(wildcard include/config/DEFAULT_HOSTNAME) \
  include/generated/uapi/linux/version.h \

arch/x86/entry/vdso/vdso-note.o: $(deps_arch/x86/entry/vdso/vdso-note.o)

$(deps_arch/x86/entry/vdso/vdso-note.o):
