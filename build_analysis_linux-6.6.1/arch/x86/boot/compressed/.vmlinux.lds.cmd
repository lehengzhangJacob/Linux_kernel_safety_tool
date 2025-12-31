savedcmd_arch/x86/boot/compressed/vmlinux.lds := gcc -E -Wp,-MMD,arch/x86/boot/compressed/.vmlinux.lds.d -nostdinc -I/home/jacob/contest/linux-6.6.1/arch/x86/include -I./arch/x86/include/generated -I/home/jacob/contest/linux-6.6.1/include -I./include -I/home/jacob/contest/linux-6.6.1/arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I/home/jacob/contest/linux-6.6.1/include/uapi -I./include/generated/uapi -include /home/jacob/contest/linux-6.6.1/include/linux/compiler-version.h -include /home/jacob/contest/linux-6.6.1/include/linux/kconfig.h -D__KERNEL__ -fmacro-prefix-map=/home/jacob/contest/linux-6.6.1/= -Werror   -I /home/jacob/contest/linux-6.6.1/arch/x86/boot/compressed -I ./arch/x86/boot/compressed -P -Ux86 -D__ASSEMBLY__ -DLINKER_SCRIPT -o arch/x86/boot/compressed/vmlinux.lds /home/jacob/contest/linux-6.6.1/arch/x86/boot/compressed/vmlinux.lds.S

source_arch/x86/boot/compressed/vmlinux.lds := /home/jacob/contest/linux-6.6.1/arch/x86/boot/compressed/vmlinux.lds.S

deps_arch/x86/boot/compressed/vmlinux.lds := \
    $(wildcard include/config/OUTPUT_FORMAT) \
    $(wildcard include/config/X86_64) \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler-version.h \
    $(wildcard include/config/CC_VERSION_TEXT) \
  /home/jacob/contest/linux-6.6.1/include/linux/kconfig.h \
    $(wildcard include/config/CPU_BIG_ENDIAN) \
    $(wildcard include/config/BOOGER) \
    $(wildcard include/config/FOO) \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/vmlinux.lds.h \
    $(wildcard include/config/FUNCTION_ALIGNMENT) \
    $(wildcard include/config/LD_DEAD_CODE_DATA_ELIMINATION) \
    $(wildcard include/config/LTO_CLANG) \
    $(wildcard include/config/MEMORY_HOTPLUG) \
    $(wildcard include/config/HAVE_DYNAMIC_FTRACE_NO_PATCHABLE) \
    $(wildcard include/config/ARCH_SUPPORTS_CFI_CLANG) \
    $(wildcard include/config/FTRACE_MCOUNT_RECORD) \
    $(wildcard include/config/FUNCTION_TRACER) \
    $(wildcard include/config/TRACE_BRANCH_PROFILING) \
    $(wildcard include/config/PROFILE_ALL_BRANCHES) \
    $(wildcard include/config/KPROBES) \
    $(wildcard include/config/FUNCTION_ERROR_INJECTION) \
    $(wildcard include/config/EVENT_TRACING) \
    $(wildcard include/config/TRACING) \
    $(wildcard include/config/FTRACE_SYSCALLS) \
    $(wildcard include/config/BPF_EVENTS) \
    $(wildcard include/config/SERIAL_EARLYCON) \
    $(wildcard include/config/SECURITY) \
    $(wildcard include/config/TIMER_OF) \
    $(wildcard include/config/IRQCHIP) \
    $(wildcard include/config/COMMON_CLK) \
    $(wildcard include/config/OF_RESERVED_MEM) \
    $(wildcard include/config/SMP) \
    $(wildcard include/config/CPU_IDLE) \
    $(wildcard include/config/ACPI) \
    $(wildcard include/config/THERMAL) \
    $(wildcard include/config/HAVE_STATIC_CALL_INLINE) \
    $(wildcard include/config/ARCH_USES_CFI_TRAPS) \
    $(wildcard include/config/DEBUG_INFO_BTF) \
    $(wildcard include/config/CONSTRUCTORS) \
    $(wildcard include/config/GENERIC_BUG) \
    $(wildcard include/config/UNWINDER_ORC) \
    $(wildcard include/config/FW_LOADER) \
    $(wildcard include/config/PM_TRACE) \
    $(wildcard include/config/PRINTK_INDEX) \
    $(wildcard include/config/BLK_DEV_INITRD) \
    $(wildcard include/config/AMD_MEM_ENCRYPT) \
    $(wildcard include/config/UNWIND_TABLES) \
    $(wildcard include/config/GCOV_KERNEL) \
    $(wildcard include/config/KASAN_GENERIC) \
    $(wildcard include/config/KCSAN) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cache.h \
    $(wildcard include/config/X86_L1_CACHE_SHIFT) \
    $(wildcard include/config/X86_INTERNODE_CACHE_SHIFT) \
    $(wildcard include/config/X86_VSMP) \
  /home/jacob/contest/linux-6.6.1/include/linux/linkage.h \
    $(wildcard include/config/ARCH_USE_SYM_ANNOTATIONS) \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler_types.h \
    $(wildcard include/config/PAHOLE_HAS_BTF_TAG) \
    $(wildcard include/config/CC_IS_GCC) \
    $(wildcard include/config/ARM64) \
    $(wildcard include/config/HAVE_ARCH_COMPILER_H) \
    $(wildcard include/config/CC_HAS_ASM_INLINE) \
  /home/jacob/contest/linux-6.6.1/include/linux/stringify.h \
  /home/jacob/contest/linux-6.6.1/include/linux/export.h \
    $(wildcard include/config/MODVERSIONS) \
    $(wildcard include/config/64BIT) \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler.h \
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
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page_types.h \
    $(wildcard include/config/PHYSICAL_START) \
    $(wildcard include/config/PHYSICAL_ALIGN) \
    $(wildcard include/config/DYNAMIC_PHYSICAL_MASK) \
  /home/jacob/contest/linux-6.6.1/include/linux/const.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/const.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/const.h \
  /home/jacob/contest/linux-6.6.1/include/linux/mem_encrypt.h \
    $(wildcard include/config/ARCH_HAS_MEM_ENCRYPT) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page_64_types.h \
    $(wildcard include/config/KASAN) \
    $(wildcard include/config/DYNAMIC_MEMORY_LAYOUT) \
    $(wildcard include/config/X86_5LEVEL) \
    $(wildcard include/config/RANDOMIZE_BASE) \

arch/x86/boot/compressed/vmlinux.lds: $(deps_arch/x86/boot/compressed/vmlinux.lds)

$(deps_arch/x86/boot/compressed/vmlinux.lds):
