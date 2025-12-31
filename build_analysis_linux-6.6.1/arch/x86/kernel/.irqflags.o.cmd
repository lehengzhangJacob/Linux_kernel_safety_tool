savedcmd_arch/x86/kernel/irqflags.o := gcc -Wp,-MMD,arch/x86/kernel/.irqflags.o.d -nostdinc -I/home/jacob/contest/linux-6.6.1/arch/x86/include -I./arch/x86/include/generated -I/home/jacob/contest/linux-6.6.1/include -I./include -I/home/jacob/contest/linux-6.6.1/arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I/home/jacob/contest/linux-6.6.1/include/uapi -I./include/generated/uapi -include /home/jacob/contest/linux-6.6.1/include/linux/compiler-version.h -include /home/jacob/contest/linux-6.6.1/include/linux/kconfig.h -D__KERNEL__ -fmacro-prefix-map=/home/jacob/contest/linux-6.6.1/= -Werror -D__ASSEMBLY__ -fno-PIE -m64 -I /home/jacob/contest/linux-6.6.1/arch/x86/kernel -I ./arch/x86/kernel    -c -o arch/x86/kernel/irqflags.o /home/jacob/contest/linux-6.6.1/arch/x86/kernel/irqflags.S 

source_arch/x86/kernel/irqflags.o := /home/jacob/contest/linux-6.6.1/arch/x86/kernel/irqflags.S

deps_arch/x86/kernel/irqflags.o := \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler-version.h \
    $(wildcard include/config/CC_VERSION_TEXT) \
  /home/jacob/contest/linux-6.6.1/include/linux/kconfig.h \
    $(wildcard include/config/CPU_BIG_ENDIAN) \
    $(wildcard include/config/BOOGER) \
    $(wildcard include/config/FOO) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/asm.h \
    $(wildcard include/config/KPROBES) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/extable_fixup_types.h \
  arch/x86/include/generated/asm/export.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/export.h \
  /home/jacob/contest/linux-6.6.1/include/linux/export.h \
    $(wildcard include/config/MODVERSIONS) \
    $(wildcard include/config/64BIT) \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler.h \
    $(wildcard include/config/TRACE_BRANCH_PROFILING) \
    $(wildcard include/config/PROFILE_ALL_BRANCHES) \
    $(wildcard include/config/OBJTOOL) \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler_types.h \
    $(wildcard include/config/DEBUG_INFO_BTF) \
    $(wildcard include/config/PAHOLE_HAS_BTF_TAG) \
    $(wildcard include/config/FUNCTION_ALIGNMENT) \
    $(wildcard include/config/CC_IS_GCC) \
    $(wildcard include/config/X86_64) \
    $(wildcard include/config/ARM64) \
    $(wildcard include/config/HAVE_ARCH_COMPILER_H) \
    $(wildcard include/config/CC_HAS_ASM_INLINE) \
  arch/x86/include/generated/asm/rwonce.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/rwonce.h \
  /home/jacob/contest/linux-6.6.1/include/linux/linkage.h \
    $(wildcard include/config/ARCH_USE_SYM_ANNOTATIONS) \
  /home/jacob/contest/linux-6.6.1/include/linux/stringify.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/linkage.h \
    $(wildcard include/config/X86_32) \
    $(wildcard include/config/CALL_PADDING) \
    $(wildcard include/config/RETHUNK) \
    $(wildcard include/config/RETPOLINE) \
    $(wildcard include/config/SLS) \
    $(wildcard include/config/FUNCTION_PADDING_BYTES) \
    $(wildcard include/config/UML) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/ibt.h \
    $(wildcard include/config/X86_KERNEL_IBT) \
  /home/jacob/contest/linux-6.6.1/include/linux/types.h \
    $(wildcard include/config/HAVE_UID16) \
    $(wildcard include/config/UID16) \
    $(wildcard include/config/ARCH_DMA_ADDR_T_64BIT) \
    $(wildcard include/config/PHYS_ADDR_T_64BIT) \
    $(wildcard include/config/ARCH_32BIT_USTAT_F_TINODE) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/types.h \
  arch/x86/include/generated/uapi/asm/types.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/types.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/int-ll64.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/int-ll64.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/bitsperlong.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitsperlong.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/bitsperlong.h \

arch/x86/kernel/irqflags.o: $(deps_arch/x86/kernel/irqflags.o)

$(deps_arch/x86/kernel/irqflags.o):
