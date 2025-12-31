savedcmd_arch/x86/kernel/cpu/powerflags.o := gcc -Wp,-MMD,arch/x86/kernel/cpu/.powerflags.o.d -nostdinc -I/home/jacob/contest/linux-6.6.1/arch/x86/include -I./arch/x86/include/generated -I/home/jacob/contest/linux-6.6.1/include -I./include -I/home/jacob/contest/linux-6.6.1/arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I/home/jacob/contest/linux-6.6.1/include/uapi -I./include/generated/uapi -include /home/jacob/contest/linux-6.6.1/include/linux/compiler-version.h -include /home/jacob/contest/linux-6.6.1/include/linux/kconfig.h -include /home/jacob/contest/linux-6.6.1/include/linux/compiler_types.h -D__KERNEL__ -fmacro-prefix-map=/home/jacob/contest/linux-6.6.1/= -Werror -std=gnu11 -fshort-wchar -funsigned-char -fno-common -fno-PIE -fno-strict-aliasing -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -fcf-protection=branch -fno-jump-tables -m64 -falign-jumps=1 -falign-loops=1 -mno-80387 -mno-fp-ret-in-387 -mpreferred-stack-boundary=3 -mskip-rax-setup -mtune=generic -mno-red-zone -mcmodel=kernel -Wno-sign-compare -fno-asynchronous-unwind-tables -mindirect-branch=thunk-extern -mindirect-branch-register -mindirect-branch-cs-prefix -mfunction-return=thunk-extern -fno-jump-tables -fpatchable-function-entry=16,16 -fno-delete-null-pointer-checks -O2 -fno-allow-store-data-races -fstack-protector-strong -fomit-frame-pointer -ftrivial-auto-var-init=zero -fno-stack-clash-protection -falign-functions=16 -fstrict-flex-arrays=3 -fno-strict-overflow -fno-stack-check -fconserve-stack -Wall -Wundef -Werror=implicit-function-declaration -Werror=implicit-int -Werror=return-type -Werror=strict-prototypes -Wno-format-security -Wno-trigraphs -Wno-frame-address -Wno-address-of-packed-member -Wframe-larger-than=2048 -Wno-main -Wno-unused-but-set-variable -Wno-unused-const-variable -Wno-dangling-pointer -Wvla -Wno-pointer-sign -Wcast-function-type -Wno-array-bounds -Wno-alloc-size-larger-than -Wimplicit-fallthrough=5 -Werror=date-time -Werror=incompatible-pointer-types -Werror=designated-init -Wenum-conversion -Wno-unused-but-set-variable -Wno-unused-const-variable -Wno-restrict -Wno-packed-not-aligned -Wno-format-overflow -Wno-format-truncation -Wno-stringop-overflow -Wno-stringop-truncation -Wno-missing-field-initializers -Wno-type-limits -Wno-shift-negative-value -Wno-maybe-uninitialized -Wno-sign-compare -fplugin=/home/jacob/contest/src/plugin/analyzer_plugin.so -I /home/jacob/contest/linux-6.6.1/arch/x86/kernel/cpu -I ./arch/x86/kernel/cpu    -DKBUILD_MODFILE='"arch/x86/kernel/cpu/powerflags"' -DKBUILD_BASENAME='"powerflags"' -DKBUILD_MODNAME='"powerflags"' -D__KBUILD_MODNAME=kmod_powerflags -c -o arch/x86/kernel/cpu/powerflags.o /home/jacob/contest/linux-6.6.1/arch/x86/kernel/cpu/powerflags.c  

source_arch/x86/kernel/cpu/powerflags.o := /home/jacob/contest/linux-6.6.1/arch/x86/kernel/cpu/powerflags.c

deps_arch/x86/kernel/cpu/powerflags.o := \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler-version.h \
    $(wildcard include/config/CC_VERSION_TEXT) \
  /home/jacob/contest/linux-6.6.1/include/linux/kconfig.h \
    $(wildcard include/config/CPU_BIG_ENDIAN) \
    $(wildcard include/config/BOOGER) \
    $(wildcard include/config/FOO) \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler_types.h \
    $(wildcard include/config/DEBUG_INFO_BTF) \
    $(wildcard include/config/PAHOLE_HAS_BTF_TAG) \
    $(wildcard include/config/FUNCTION_ALIGNMENT) \
    $(wildcard include/config/CC_IS_GCC) \
    $(wildcard include/config/X86_64) \
    $(wildcard include/config/ARM64) \
    $(wildcard include/config/HAVE_ARCH_COMPILER_H) \
    $(wildcard include/config/CC_HAS_ASM_INLINE) \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler_attributes.h \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler-gcc.h \
    $(wildcard include/config/RETPOLINE) \
    $(wildcard include/config/ARCH_USE_BUILTIN_BSWAP) \
    $(wildcard include/config/SHADOW_CALL_STACK) \
    $(wildcard include/config/KCOV) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cpufeature.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/processor.h \
    $(wildcard include/config/X86_VSMP) \
    $(wildcard include/config/X86_VMX_FEATURE_NAMES) \
    $(wildcard include/config/SMP) \
    $(wildcard include/config/X86_32) \
    $(wildcard include/config/X86_IOPL_IOPERM) \
    $(wildcard include/config/STACKPROTECTOR) \
    $(wildcard include/config/VM86) \
    $(wildcard include/config/X86_USER_SHADOW_STACK) \
    $(wildcard include/config/PARAVIRT_XXL) \
    $(wildcard include/config/X86_DEBUGCTLMSR) \
    $(wildcard include/config/CPU_SUP_AMD) \
    $(wildcard include/config/XEN) \
    $(wildcard include/config/X86_SGX) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/processor-flags.h \
    $(wildcard include/config/PAGE_TABLE_ISOLATION) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/processor-flags.h \
  /home/jacob/contest/linux-6.6.1/include/linux/const.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/const.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/const.h \
  /home/jacob/contest/linux-6.6.1/include/linux/mem_encrypt.h \
    $(wildcard include/config/ARCH_HAS_MEM_ENCRYPT) \
    $(wildcard include/config/AMD_MEM_ENCRYPT) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/mem_encrypt.h \
    $(wildcard include/config/X86_MEM_ENCRYPT) \
  /home/jacob/contest/linux-6.6.1/include/linux/init.h \
    $(wildcard include/config/HAVE_ARCH_PREL32_RELOCATIONS) \
    $(wildcard include/config/STRICT_KERNEL_RWX) \
    $(wildcard include/config/STRICT_MODULE_RWX) \
    $(wildcard include/config/LTO_CLANG) \
  /home/jacob/contest/linux-6.6.1/include/linux/build_bug.h \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler.h \
    $(wildcard include/config/TRACE_BRANCH_PROFILING) \
    $(wildcard include/config/PROFILE_ALL_BRANCHES) \
    $(wildcard include/config/OBJTOOL) \
  arch/x86/include/generated/asm/rwonce.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/rwonce.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kasan-checks.h \
    $(wildcard include/config/KASAN_GENERIC) \
    $(wildcard include/config/KASAN_SW_TAGS) \
  /home/jacob/contest/linux-6.6.1/include/linux/types.h \
    $(wildcard include/config/HAVE_UID16) \
    $(wildcard include/config/UID16) \
    $(wildcard include/config/ARCH_DMA_ADDR_T_64BIT) \
    $(wildcard include/config/PHYS_ADDR_T_64BIT) \
    $(wildcard include/config/64BIT) \
    $(wildcard include/config/ARCH_32BIT_USTAT_F_TINODE) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/types.h \
  arch/x86/include/generated/uapi/asm/types.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/types.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/int-ll64.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/int-ll64.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/bitsperlong.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitsperlong.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/bitsperlong.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/posix_types.h \
  /home/jacob/contest/linux-6.6.1/include/linux/stddef.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/stddef.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/posix_types.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/posix_types_64.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/posix_types.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kcsan-checks.h \
    $(wildcard include/config/KCSAN) \
    $(wildcard include/config/KCSAN_WEAK_MEMORY) \
    $(wildcard include/config/KCSAN_IGNORE_ATOMICS) \
  /home/jacob/contest/linux-6.6.1/include/linux/stringify.h \
  /home/jacob/contest/linux-6.6.1/include/linux/cc_platform.h \
    $(wildcard include/config/ARCH_HAS_CC_PLATFORM) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/bootparam.h \
  /home/jacob/contest/linux-6.6.1/include/linux/screen_info.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/screen_info.h \
  /home/jacob/contest/linux-6.6.1/include/linux/apm_bios.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/apm_bios.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/ioctl.h \
  arch/x86/include/generated/uapi/asm/ioctl.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/ioctl.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/ioctl.h \
  /home/jacob/contest/linux-6.6.1/include/linux/edd.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/edd.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/ist.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/ist.h \
  /home/jacob/contest/linux-6.6.1/include/video/edid.h \
    $(wildcard include/config/X86) \
  /home/jacob/contest/linux-6.6.1/include/uapi/video/edid.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/math_emu.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/ptrace.h \
    $(wildcard include/config/PARAVIRT) \
    $(wildcard include/config/IA32_EMULATION) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/segment.h \
    $(wildcard include/config/XEN_PV) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/alternative.h \
    $(wildcard include/config/CALL_THUNKS) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/asm.h \
    $(wildcard include/config/KPROBES) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/extable_fixup_types.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/ibt.h \
    $(wildcard include/config/X86_KERNEL_IBT) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cache.h \
    $(wildcard include/config/X86_L1_CACHE_SHIFT) \
    $(wildcard include/config/X86_INTERNODE_CACHE_SHIFT) \
  /home/jacob/contest/linux-6.6.1/include/linux/linkage.h \
    $(wildcard include/config/ARCH_USE_SYM_ANNOTATIONS) \
  /home/jacob/contest/linux-6.6.1/include/linux/export.h \
    $(wildcard include/config/MODVERSIONS) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/linkage.h \
    $(wildcard include/config/CALL_PADDING) \
    $(wildcard include/config/RETHUNK) \
    $(wildcard include/config/SLS) \
    $(wildcard include/config/FUNCTION_PADDING_BYTES) \
    $(wildcard include/config/UML) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page_types.h \
    $(wildcard include/config/PHYSICAL_START) \
    $(wildcard include/config/PHYSICAL_ALIGN) \
    $(wildcard include/config/DYNAMIC_PHYSICAL_MASK) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page_64_types.h \
    $(wildcard include/config/KASAN) \
    $(wildcard include/config/DYNAMIC_MEMORY_LAYOUT) \
    $(wildcard include/config/X86_5LEVEL) \
    $(wildcard include/config/RANDOMIZE_BASE) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/kaslr.h \
    $(wildcard include/config/RANDOMIZE_MEMORY) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/ptrace.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/ptrace-abi.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/paravirt_types.h \
    $(wildcard include/config/PGTABLE_LEVELS) \
    $(wildcard include/config/ZERO_CALL_USED_REGS) \
    $(wildcard include/config/PARAVIRT_DEBUG) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/desc_defs.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/pgtable_types.h \
    $(wildcard include/config/X86_INTEL_MEMORY_PROTECTION_KEYS) \
    $(wildcard include/config/X86_PAE) \
    $(wildcard include/config/MEM_SOFT_DIRTY) \
    $(wildcard include/config/HAVE_ARCH_USERFAULTFD_WP) \
    $(wildcard include/config/PROC_FS) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/pgtable_64_types.h \
    $(wildcard include/config/KMSAN) \
    $(wildcard include/config/DEBUG_KMAP_LOCAL_FORCE_MAP) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/sparsemem.h \
    $(wildcard include/config/SPARSEMEM) \
    $(wildcard include/config/NUMA_KEEP_MEMINFO) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/nospec-branch.h \
    $(wildcard include/config/CALL_THUNKS_DEBUG) \
    $(wildcard include/config/CALL_DEPTH_TRACKING) \
    $(wildcard include/config/NOINSTR_VALIDATION) \
    $(wildcard include/config/CPU_UNRET_ENTRY) \
    $(wildcard include/config/CPU_SRSO) \
    $(wildcard include/config/CPU_IBPB_ENTRY) \
  /home/jacob/contest/linux-6.6.1/include/linux/static_key.h \
  /home/jacob/contest/linux-6.6.1/include/linux/jump_label.h \
    $(wildcard include/config/JUMP_LABEL) \
    $(wildcard include/config/HAVE_ARCH_JUMP_LABEL_RELATIVE) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/jump_label.h \
    $(wildcard include/config/HAVE_JUMP_LABEL_HACK) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/nops.h \
  /home/jacob/contest/linux-6.6.1/include/linux/objtool.h \
    $(wildcard include/config/FRAME_POINTER) \
  /home/jacob/contest/linux-6.6.1/include/linux/objtool_types.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cpufeatures.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/required-features.h \
    $(wildcard include/config/X86_MINIMUM_CPU_FAMILY) \
    $(wildcard include/config/MATH_EMULATION) \
    $(wildcard include/config/X86_CMPXCHG64) \
    $(wildcard include/config/X86_CMOV) \
    $(wildcard include/config/X86_P6_NOP) \
    $(wildcard include/config/MATOM) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/disabled-features.h \
    $(wildcard include/config/X86_UMIP) \
    $(wildcard include/config/ADDRESS_MASKING) \
    $(wildcard include/config/INTEL_IOMMU_SVM) \
    $(wildcard include/config/INTEL_TDX_GUEST) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/msr-index.h \
  /home/jacob/contest/linux-6.6.1/include/linux/bits.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/bits.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/unwind_hints.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/orc_types.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/byteorder.h \
  /home/jacob/contest/linux-6.6.1/include/linux/byteorder/little_endian.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/byteorder/little_endian.h \
  /home/jacob/contest/linux-6.6.1/include/linux/swab.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/swab.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/swab.h \
  /home/jacob/contest/linux-6.6.1/include/linux/byteorder/generic.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/percpu.h \
    $(wildcard include/config/X86_64_SMP) \
  /home/jacob/contest/linux-6.6.1/include/linux/kernel.h \
    $(wildcard include/config/PREEMPT_VOLUNTARY_BUILD) \
    $(wildcard include/config/PREEMPT_DYNAMIC) \
    $(wildcard include/config/HAVE_PREEMPT_DYNAMIC_CALL) \
    $(wildcard include/config/HAVE_PREEMPT_DYNAMIC_KEY) \
    $(wildcard include/config/PREEMPT_) \
    $(wildcard include/config/DEBUG_ATOMIC_SLEEP) \
    $(wildcard include/config/MMU) \
    $(wildcard include/config/PROVE_LOCKING) \
    $(wildcard include/config/TRACING) \
    $(wildcard include/config/FTRACE_MCOUNT_RECORD) \
  /home/jacob/contest/linux-6.6.1/include/linux/stdarg.h \
  /home/jacob/contest/linux-6.6.1/include/linux/align.h \
  /home/jacob/contest/linux-6.6.1/include/linux/limits.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/limits.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/limits.h \
  /home/jacob/contest/linux-6.6.1/include/linux/container_of.h \
  /home/jacob/contest/linux-6.6.1/include/linux/bitops.h \
  /home/jacob/contest/linux-6.6.1/include/linux/typecheck.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/kernel.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/sysinfo.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/generic-non-atomic.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/barrier.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/barrier.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/bitops.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/rmwcc.h \
  /home/jacob/contest/linux-6.6.1/include/linux/args.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/sched.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/arch_hweight.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/const_hweight.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/instrumented-atomic.h \
  /home/jacob/contest/linux-6.6.1/include/linux/instrumented.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kmsan-checks.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/instrumented-non-atomic.h \
    $(wildcard include/config/KCSAN_ASSUME_PLAIN_WRITES_ATOMIC) \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/instrumented-lock.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/le.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/ext2-atomic-setbit.h \
  /home/jacob/contest/linux-6.6.1/include/linux/hex.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kstrtox.h \
  /home/jacob/contest/linux-6.6.1/include/linux/log2.h \
    $(wildcard include/config/ARCH_HAS_ILOG2_U32) \
    $(wildcard include/config/ARCH_HAS_ILOG2_U64) \
  /home/jacob/contest/linux-6.6.1/include/linux/math.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/div64.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/div64.h \
  /home/jacob/contest/linux-6.6.1/include/linux/minmax.h \
  /home/jacob/contest/linux-6.6.1/include/linux/panic.h \
    $(wildcard include/config/PANIC_TIMEOUT) \
  /home/jacob/contest/linux-6.6.1/include/linux/printk.h \
    $(wildcard include/config/MESSAGE_LOGLEVEL_DEFAULT) \
    $(wildcard include/config/CONSOLE_LOGLEVEL_DEFAULT) \
    $(wildcard include/config/CONSOLE_LOGLEVEL_QUIET) \
    $(wildcard include/config/EARLY_PRINTK) \
    $(wildcard include/config/PRINTK) \
    $(wildcard include/config/PRINTK_INDEX) \
    $(wildcard include/config/DYNAMIC_DEBUG) \
    $(wildcard include/config/DYNAMIC_DEBUG_CORE) \
  /home/jacob/contest/linux-6.6.1/include/linux/kern_levels.h \
  /home/jacob/contest/linux-6.6.1/include/linux/ratelimit_types.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/param.h \
  arch/x86/include/generated/uapi/asm/param.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/param.h \
    $(wildcard include/config/HZ) \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/param.h \
  /home/jacob/contest/linux-6.6.1/include/linux/spinlock_types_raw.h \
    $(wildcard include/config/DEBUG_SPINLOCK) \
    $(wildcard include/config/DEBUG_LOCK_ALLOC) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/spinlock_types.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/qspinlock_types.h \
    $(wildcard include/config/NR_CPUS) \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/qrwlock_types.h \
  /home/jacob/contest/linux-6.6.1/include/linux/lockdep_types.h \
    $(wildcard include/config/PROVE_RAW_LOCK_NESTING) \
    $(wildcard include/config/LOCKDEP) \
    $(wildcard include/config/LOCK_STAT) \
  /home/jacob/contest/linux-6.6.1/include/linux/once_lite.h \
  /home/jacob/contest/linux-6.6.1/include/linux/sprintf.h \
  /home/jacob/contest/linux-6.6.1/include/linux/static_call_types.h \
    $(wildcard include/config/HAVE_STATIC_CALL) \
    $(wildcard include/config/HAVE_STATIC_CALL_INLINE) \
  /home/jacob/contest/linux-6.6.1/include/linux/instruction_pointer.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/percpu.h \
    $(wildcard include/config/DEBUG_PREEMPT) \
    $(wildcard include/config/HAVE_SETUP_PER_CPU_AREA) \
  /home/jacob/contest/linux-6.6.1/include/linux/threads.h \
    $(wildcard include/config/BASE_SMALL) \
  /home/jacob/contest/linux-6.6.1/include/linux/percpu-defs.h \
    $(wildcard include/config/DEBUG_FORCE_WEAK_PER_CPU) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/current.h \
  /home/jacob/contest/linux-6.6.1/include/linux/cache.h \
    $(wildcard include/config/ARCH_HAS_CACHE_LINE_SIZE) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/asm-offsets.h \
  include/generated/asm-offsets.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/GEN-for-each-reg.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/proto.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/ldt.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/sigcontext.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cpuid.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/string.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/string_64.h \
    $(wildcard include/config/ARCH_HAS_UACCESS_FLUSHCACHE) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page_64.h \
    $(wildcard include/config/DEBUG_VIRTUAL) \
    $(wildcard include/config/X86_VSYSCALL_EMULATION) \
  /home/jacob/contest/linux-6.6.1/include/linux/range.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/memory_model.h \
    $(wildcard include/config/FLATMEM) \
    $(wildcard include/config/SPARSEMEM_VMEMMAP) \
  /home/jacob/contest/linux-6.6.1/include/linux/pfn.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/getorder.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/msr.h \
    $(wildcard include/config/TRACEPOINTS) \
  arch/x86/include/generated/uapi/asm/errno.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/errno.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/errno-base.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cpumask.h \
  /home/jacob/contest/linux-6.6.1/include/linux/cpumask.h \
    $(wildcard include/config/FORCE_NR_CPUS) \
    $(wildcard include/config/HOTPLUG_CPU) \
    $(wildcard include/config/DEBUG_PER_CPU_MAPS) \
    $(wildcard include/config/CPUMASK_OFFSTACK) \
  /home/jacob/contest/linux-6.6.1/include/linux/bitmap.h \
  /home/jacob/contest/linux-6.6.1/include/linux/find.h \
  /home/jacob/contest/linux-6.6.1/include/linux/string.h \
    $(wildcard include/config/BINARY_PRINTF) \
    $(wildcard include/config/FORTIFY_SOURCE) \
  /home/jacob/contest/linux-6.6.1/include/linux/errno.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/errno.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/string.h \
  /home/jacob/contest/linux-6.6.1/include/linux/atomic.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/atomic.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cmpxchg.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cmpxchg_64.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/atomic64_64.h \
  /home/jacob/contest/linux-6.6.1/include/linux/atomic/atomic-arch-fallback.h \
    $(wildcard include/config/GENERIC_ATOMIC64) \
  /home/jacob/contest/linux-6.6.1/include/linux/atomic/atomic-long.h \
  /home/jacob/contest/linux-6.6.1/include/linux/atomic/atomic-instrumented.h \
  /home/jacob/contest/linux-6.6.1/include/linux/bug.h \
    $(wildcard include/config/GENERIC_BUG) \
    $(wildcard include/config/BUG_ON_DATA_CORRUPTION) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/bug.h \
    $(wildcard include/config/DEBUG_BUGVERBOSE) \
  /home/jacob/contest/linux-6.6.1/include/linux/instrumentation.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bug.h \
    $(wildcard include/config/BUG) \
    $(wildcard include/config/GENERIC_BUG_RELATIVE_POINTERS) \
  /home/jacob/contest/linux-6.6.1/include/linux/gfp_types.h \
    $(wildcard include/config/KASAN_HW_TAGS) \
  /home/jacob/contest/linux-6.6.1/include/linux/numa.h \
    $(wildcard include/config/NODES_SHIFT) \
    $(wildcard include/config/NUMA) \
    $(wildcard include/config/HAVE_ARCH_NODE_DEV_GROUP) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/msr.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/shared/msr.h \
  /home/jacob/contest/linux-6.6.1/include/linux/tracepoint-defs.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/special_insns.h \
  /home/jacob/contest/linux-6.6.1/include/linux/irqflags.h \
    $(wildcard include/config/TRACE_IRQFLAGS) \
    $(wildcard include/config/PREEMPT_RT) \
    $(wildcard include/config/IRQSOFF_TRACER) \
    $(wildcard include/config/PREEMPT_TRACER) \
    $(wildcard include/config/DEBUG_IRQFLAGS) \
    $(wildcard include/config/TRACE_IRQFLAGS_SUPPORT) \
  /home/jacob/contest/linux-6.6.1/include/linux/cleanup.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/irqflags.h \
    $(wildcard include/config/DEBUG_ENTRY) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/fpu/types.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/vmxfeatures.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/vdso/processor.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/shstk.h \
  /home/jacob/contest/linux-6.6.1/include/linux/personality.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/personality.h \
  /home/jacob/contest/linux-6.6.1/include/linux/math64.h \
    $(wildcard include/config/ARCH_SUPPORTS_INT128) \
  /home/jacob/contest/linux-6.6.1/include/vdso/math64.h \
  /home/jacob/contest/linux-6.6.1/include/linux/err.h \

arch/x86/kernel/cpu/powerflags.o: $(deps_arch/x86/kernel/cpu/powerflags.o)

$(deps_arch/x86/kernel/cpu/powerflags.o):
