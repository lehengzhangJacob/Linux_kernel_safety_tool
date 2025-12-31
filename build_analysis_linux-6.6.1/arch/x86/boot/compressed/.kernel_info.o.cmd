savedcmd_arch/x86/boot/compressed/kernel_info.o := gcc -Wp,-MMD,arch/x86/boot/compressed/.kernel_info.o.d -nostdinc -I/home/jacob/contest/linux-6.6.1/arch/x86/include -I./arch/x86/include/generated -I/home/jacob/contest/linux-6.6.1/include -I./include -I/home/jacob/contest/linux-6.6.1/arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I/home/jacob/contest/linux-6.6.1/include/uapi -I./include/generated/uapi -include /home/jacob/contest/linux-6.6.1/include/linux/compiler-version.h -include /home/jacob/contest/linux-6.6.1/include/linux/kconfig.h -D__KERNEL__ -fmacro-prefix-map=/home/jacob/contest/linux-6.6.1/= -Werror -m64 -O2 -fno-strict-aliasing -fPIE -Wundef -DDISABLE_BRANCH_PROFILING -mcmodel=small -mno-red-zone -mno-mmx -mno-sse -ffreestanding -fshort-wchar -fno-stack-protector -Wno-address-of-packed-member -Wno-pointer-sign -fmacro-prefix-map=/home/jacob/contest/linux-6.6.1/= -fno-asynchronous-unwind-tables -D__DISABLE_EXPORTS -Wa,-mrelax-relocations=no -include /home/jacob/contest/linux-6.6.1/include/linux/hidden.h -D__ASSEMBLY__ -I /home/jacob/contest/linux-6.6.1/arch/x86/boot/compressed -I ./arch/x86/boot/compressed    -c -o arch/x86/boot/compressed/kernel_info.o /home/jacob/contest/linux-6.6.1/arch/x86/boot/compressed/kernel_info.S 

source_arch/x86/boot/compressed/kernel_info.o := /home/jacob/contest/linux-6.6.1/arch/x86/boot/compressed/kernel_info.S

deps_arch/x86/boot/compressed/kernel_info.o := \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler-version.h \
    $(wildcard include/config/CC_VERSION_TEXT) \
  /home/jacob/contest/linux-6.6.1/include/linux/kconfig.h \
    $(wildcard include/config/CPU_BIG_ENDIAN) \
    $(wildcard include/config/BOOGER) \
    $(wildcard include/config/FOO) \
  /home/jacob/contest/linux-6.6.1/include/linux/hidden.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/bootparam.h \

arch/x86/boot/compressed/kernel_info.o: $(deps_arch/x86/boot/compressed/kernel_info.o)

$(deps_arch/x86/boot/compressed/kernel_info.o):
