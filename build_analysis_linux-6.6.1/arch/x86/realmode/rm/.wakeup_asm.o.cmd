savedcmd_arch/x86/realmode/rm/wakeup_asm.o := gcc -Wp,-MMD,arch/x86/realmode/rm/.wakeup_asm.o.d -nostdinc -I/home/jacob/contest/linux-6.6.1/arch/x86/include -I./arch/x86/include/generated -I/home/jacob/contest/linux-6.6.1/include -I./include -I/home/jacob/contest/linux-6.6.1/arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I/home/jacob/contest/linux-6.6.1/include/uapi -I./include/generated/uapi -include /home/jacob/contest/linux-6.6.1/include/linux/compiler-version.h -include /home/jacob/contest/linux-6.6.1/include/linux/kconfig.h -D__KERNEL__ -fmacro-prefix-map=/home/jacob/contest/linux-6.6.1/= -Werror -m16 -g -Os -DDISABLE_BRANCH_PROFILING -D__DISABLE_EXPORTS -Wall -Wstrict-prototypes -march=i386 -mregparm=3 -fno-strict-aliasing -fomit-frame-pointer -fno-pic -mno-mmx -mno-sse -fcf-protection=none -ffreestanding -fno-stack-protector -Wno-address-of-packed-member -mpreferred-stack-boundary=2 -D_SETUP -D_WAKEUP -I/home/jacob/contest/linux-6.6.1/arch/x86/boot -D__ASSEMBLY__ -I /home/jacob/contest/linux-6.6.1/arch/x86/realmode/rm -I ./arch/x86/realmode/rm    -c -o arch/x86/realmode/rm/wakeup_asm.o /home/jacob/contest/linux-6.6.1/arch/x86/realmode/rm/wakeup_asm.S 

source_arch/x86/realmode/rm/wakeup_asm.o := /home/jacob/contest/linux-6.6.1/arch/x86/realmode/rm/wakeup_asm.S

deps_arch/x86/realmode/rm/wakeup_asm.o := \
    $(wildcard include/config/64BIT) \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler-version.h \
    $(wildcard include/config/CC_VERSION_TEXT) \
  /home/jacob/contest/linux-6.6.1/include/linux/kconfig.h \
    $(wildcard include/config/CPU_BIG_ENDIAN) \
    $(wildcard include/config/BOOGER) \
    $(wildcard include/config/FOO) \
  /home/jacob/contest/linux-6.6.1/include/linux/linkage.h \
    $(wildcard include/config/FUNCTION_ALIGNMENT) \
    $(wildcard include/config/ARCH_USE_SYM_ANNOTATIONS) \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler_types.h \
    $(wildcard include/config/DEBUG_INFO_BTF) \
    $(wildcard include/config/PAHOLE_HAS_BTF_TAG) \
    $(wildcard include/config/CC_IS_GCC) \
    $(wildcard include/config/X86_64) \
    $(wildcard include/config/ARM64) \
    $(wildcard include/config/HAVE_ARCH_COMPILER_H) \
    $(wildcard include/config/CC_HAS_ASM_INLINE) \
  /home/jacob/contest/linux-6.6.1/include/linux/stringify.h \
  /home/jacob/contest/linux-6.6.1/include/linux/export.h \
    $(wildcard include/config/MODVERSIONS) \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler.h \
    $(wildcard include/config/TRACE_BRANCH_PROFILING) \
    $(wildcard include/config/PROFILE_ALL_BRANCHES) \
    $(wildcard include/config/OBJTOOL) \
  arch/x86/include/generated/asm/rwonce.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/rwonce.h \
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
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/segment.h \
    $(wildcard include/config/SMP) \
    $(wildcard include/config/XEN_PV) \
  /home/jacob/contest/linux-6.6.1/include/linux/const.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/const.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/const.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/alternative.h \
    $(wildcard include/config/CALL_THUNKS) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/asm.h \
    $(wildcard include/config/KPROBES) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/extable_fixup_types.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cache.h \
    $(wildcard include/config/X86_L1_CACHE_SHIFT) \
    $(wildcard include/config/X86_INTERNODE_CACHE_SHIFT) \
    $(wildcard include/config/X86_VSMP) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/msr-index.h \
  /home/jacob/contest/linux-6.6.1/include/linux/bits.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/bits.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page_types.h \
    $(wildcard include/config/PHYSICAL_START) \
    $(wildcard include/config/PHYSICAL_ALIGN) \
    $(wildcard include/config/DYNAMIC_PHYSICAL_MASK) \
  /home/jacob/contest/linux-6.6.1/include/linux/mem_encrypt.h \
    $(wildcard include/config/ARCH_HAS_MEM_ENCRYPT) \
    $(wildcard include/config/AMD_MEM_ENCRYPT) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page_64_types.h \
    $(wildcard include/config/KASAN) \
    $(wildcard include/config/DYNAMIC_MEMORY_LAYOUT) \
    $(wildcard include/config/X86_5LEVEL) \
    $(wildcard include/config/RANDOMIZE_BASE) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/pgtable_types.h \
    $(wildcard include/config/X86_INTEL_MEMORY_PROTECTION_KEYS) \
    $(wildcard include/config/X86_PAE) \
    $(wildcard include/config/MEM_SOFT_DIRTY) \
    $(wildcard include/config/HAVE_ARCH_USERFAULTFD_WP) \
    $(wildcard include/config/PGTABLE_LEVELS) \
    $(wildcard include/config/PROC_FS) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/pgtable_64_types.h \
    $(wildcard include/config/KMSAN) \
    $(wildcard include/config/DEBUG_KMAP_LOCAL_FORCE_MAP) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/sparsemem.h \
    $(wildcard include/config/SPARSEMEM) \
    $(wildcard include/config/NUMA_KEEP_MEMINFO) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/processor-flags.h \
    $(wildcard include/config/VM86) \
    $(wildcard include/config/PAGE_TABLE_ISOLATION) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/processor-flags.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/realmode/rm/realmode.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/realmode/rm/wakeup.h \

arch/x86/realmode/rm/wakeup_asm.o: $(deps_arch/x86/realmode/rm/wakeup_asm.o)

$(deps_arch/x86/realmode/rm/wakeup_asm.o):
