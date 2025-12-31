savedcmd_drivers/acpi/acpica/utascii.o := gcc -Wp,-MMD,drivers/acpi/acpica/.utascii.o.d -nostdinc -I/home/jacob/contest/linux-6.6.1/arch/x86/include -I./arch/x86/include/generated -I/home/jacob/contest/linux-6.6.1/include -I./include -I/home/jacob/contest/linux-6.6.1/arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I/home/jacob/contest/linux-6.6.1/include/uapi -I./include/generated/uapi -include /home/jacob/contest/linux-6.6.1/include/linux/compiler-version.h -include /home/jacob/contest/linux-6.6.1/include/linux/kconfig.h -include /home/jacob/contest/linux-6.6.1/include/linux/compiler_types.h -D__KERNEL__ -fmacro-prefix-map=/home/jacob/contest/linux-6.6.1/= -Werror -std=gnu11 -fshort-wchar -funsigned-char -fno-common -fno-PIE -fno-strict-aliasing -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -fcf-protection=branch -fno-jump-tables -m64 -falign-jumps=1 -falign-loops=1 -mno-80387 -mno-fp-ret-in-387 -mpreferred-stack-boundary=3 -mskip-rax-setup -mtune=generic -mno-red-zone -mcmodel=kernel -Wno-sign-compare -fno-asynchronous-unwind-tables -mindirect-branch=thunk-extern -mindirect-branch-register -mindirect-branch-cs-prefix -mfunction-return=thunk-extern -fno-jump-tables -fpatchable-function-entry=16,16 -fno-delete-null-pointer-checks -O2 -fno-allow-store-data-races -fstack-protector-strong -fomit-frame-pointer -ftrivial-auto-var-init=zero -fno-stack-clash-protection -falign-functions=16 -fstrict-flex-arrays=3 -fno-strict-overflow -fno-stack-check -fconserve-stack -Wall -Wundef -Werror=implicit-function-declaration -Werror=implicit-int -Werror=return-type -Werror=strict-prototypes -Wno-format-security -Wno-trigraphs -Wno-frame-address -Wno-address-of-packed-member -Wframe-larger-than=2048 -Wno-main -Wno-unused-but-set-variable -Wno-unused-const-variable -Wno-dangling-pointer -Wvla -Wno-pointer-sign -Wcast-function-type -Wno-array-bounds -Wno-alloc-size-larger-than -Wimplicit-fallthrough=5 -Werror=date-time -Werror=incompatible-pointer-types -Werror=designated-init -Wenum-conversion -Wno-unused-but-set-variable -Wno-unused-const-variable -Wno-restrict -Wno-packed-not-aligned -Wno-format-overflow -Wno-format-truncation -Wno-stringop-overflow -Wno-stringop-truncation -Wno-missing-field-initializers -Wno-type-limits -Wno-shift-negative-value -Wno-maybe-uninitialized -Wno-sign-compare -fplugin=/home/jacob/contest/src/plugin/analyzer_plugin.so -D_LINUX -DBUILDING_ACPICA -I /home/jacob/contest/linux-6.6.1/drivers/acpi/acpica -I ./drivers/acpi/acpica    -DKBUILD_MODFILE='"drivers/acpi/acpica/acpi"' -DKBUILD_BASENAME='"utascii"' -DKBUILD_MODNAME='"acpi"' -D__KBUILD_MODNAME=kmod_acpi -c -o drivers/acpi/acpica/utascii.o /home/jacob/contest/linux-6.6.1/drivers/acpi/acpica/utascii.c  

source_drivers/acpi/acpica/utascii.o := /home/jacob/contest/linux-6.6.1/drivers/acpi/acpica/utascii.c

deps_drivers/acpi/acpica/utascii.o := \
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
  /home/jacob/contest/linux-6.6.1/include/acpi/acpi.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/platform/acenv.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/platform/acgcc.h \
  /home/jacob/contest/linux-6.6.1/include/linux/stdarg.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/platform/aclinux.h \
    $(wildcard include/config/PCI) \
    $(wildcard include/config/ACPI_REDUCED_HARDWARE_ONLY) \
    $(wildcard include/config/ACPI_DEBUGGER) \
    $(wildcard include/config/ACPI_DEBUG) \
    $(wildcard include/config/ACPI) \
  /home/jacob/contest/linux-6.6.1/include/linux/string.h \
    $(wildcard include/config/BINARY_PRINTF) \
    $(wildcard include/config/FORTIFY_SOURCE) \
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
    $(wildcard include/config/X86_32) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/posix_types_64.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/posix_types.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kcsan-checks.h \
    $(wildcard include/config/KCSAN) \
    $(wildcard include/config/KCSAN_WEAK_MEMORY) \
    $(wildcard include/config/KCSAN_IGNORE_ATOMICS) \
  /home/jacob/contest/linux-6.6.1/include/linux/errno.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/errno.h \
  arch/x86/include/generated/uapi/asm/errno.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/errno.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/errno-base.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/string.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/string.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/string_64.h \
    $(wildcard include/config/KMSAN) \
    $(wildcard include/config/ARCH_HAS_UACCESS_FLUSHCACHE) \
  /home/jacob/contest/linux-6.6.1/include/linux/jump_label.h \
    $(wildcard include/config/JUMP_LABEL) \
    $(wildcard include/config/HAVE_ARCH_JUMP_LABEL_RELATIVE) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/jump_label.h \
    $(wildcard include/config/HAVE_JUMP_LABEL_HACK) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/asm.h \
    $(wildcard include/config/KPROBES) \
  /home/jacob/contest/linux-6.6.1/include/linux/stringify.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/extable_fixup_types.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/nops.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kernel.h \
    $(wildcard include/config/PREEMPT_VOLUNTARY_BUILD) \
    $(wildcard include/config/PREEMPT_DYNAMIC) \
    $(wildcard include/config/HAVE_PREEMPT_DYNAMIC_CALL) \
    $(wildcard include/config/HAVE_PREEMPT_DYNAMIC_KEY) \
    $(wildcard include/config/PREEMPT_) \
    $(wildcard include/config/DEBUG_ATOMIC_SLEEP) \
    $(wildcard include/config/SMP) \
    $(wildcard include/config/MMU) \
    $(wildcard include/config/PROVE_LOCKING) \
    $(wildcard include/config/TRACING) \
    $(wildcard include/config/FTRACE_MCOUNT_RECORD) \
  /home/jacob/contest/linux-6.6.1/include/linux/align.h \
  /home/jacob/contest/linux-6.6.1/include/linux/const.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/const.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/const.h \
  /home/jacob/contest/linux-6.6.1/include/linux/limits.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/limits.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/limits.h \
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
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/ibt.h \
    $(wildcard include/config/X86_KERNEL_IBT) \
  /home/jacob/contest/linux-6.6.1/include/linux/container_of.h \
  /home/jacob/contest/linux-6.6.1/include/linux/build_bug.h \
  /home/jacob/contest/linux-6.6.1/include/linux/bitops.h \
  /home/jacob/contest/linux-6.6.1/include/linux/bits.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/bits.h \
  /home/jacob/contest/linux-6.6.1/include/linux/typecheck.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/kernel.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/sysinfo.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/generic-non-atomic.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/barrier.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/alternative.h \
    $(wildcard include/config/CALL_THUNKS) \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/barrier.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/bitops.h \
    $(wildcard include/config/X86_CMOV) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/rmwcc.h \
  /home/jacob/contest/linux-6.6.1/include/linux/args.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/sched.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/arch_hweight.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cpufeatures.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/required-features.h \
    $(wildcard include/config/X86_MINIMUM_CPU_FAMILY) \
    $(wildcard include/config/MATH_EMULATION) \
    $(wildcard include/config/X86_PAE) \
    $(wildcard include/config/X86_CMPXCHG64) \
    $(wildcard include/config/X86_P6_NOP) \
    $(wildcard include/config/MATOM) \
    $(wildcard include/config/PARAVIRT_XXL) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/disabled-features.h \
    $(wildcard include/config/X86_UMIP) \
    $(wildcard include/config/X86_INTEL_MEMORY_PROTECTION_KEYS) \
    $(wildcard include/config/X86_5LEVEL) \
    $(wildcard include/config/PAGE_TABLE_ISOLATION) \
    $(wildcard include/config/CPU_UNRET_ENTRY) \
    $(wildcard include/config/CALL_DEPTH_TRACKING) \
    $(wildcard include/config/ADDRESS_MASKING) \
    $(wildcard include/config/INTEL_IOMMU_SVM) \
    $(wildcard include/config/X86_SGX) \
    $(wildcard include/config/XEN_PV) \
    $(wildcard include/config/INTEL_TDX_GUEST) \
    $(wildcard include/config/X86_USER_SHADOW_STACK) \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/const_hweight.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/instrumented-atomic.h \
  /home/jacob/contest/linux-6.6.1/include/linux/instrumented.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kmsan-checks.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/instrumented-non-atomic.h \
    $(wildcard include/config/KCSAN_ASSUME_PLAIN_WRITES_ATOMIC) \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/instrumented-lock.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/le.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/byteorder.h \
  /home/jacob/contest/linux-6.6.1/include/linux/byteorder/little_endian.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/byteorder/little_endian.h \
  /home/jacob/contest/linux-6.6.1/include/linux/swab.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/swab.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/swab.h \
  /home/jacob/contest/linux-6.6.1/include/linux/byteorder/generic.h \
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
  /home/jacob/contest/linux-6.6.1/include/linux/init.h \
    $(wildcard include/config/HAVE_ARCH_PREL32_RELOCATIONS) \
    $(wildcard include/config/STRICT_KERNEL_RWX) \
    $(wildcard include/config/STRICT_MODULE_RWX) \
    $(wildcard include/config/LTO_CLANG) \
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
  /home/jacob/contest/linux-6.6.1/include/linux/ctype.h \
  /home/jacob/contest/linux-6.6.1/include/linux/sched.h \
    $(wildcard include/config/PREEMPT_RT) \
    $(wildcard include/config/VIRT_CPU_ACCOUNTING_NATIVE) \
    $(wildcard include/config/SCHED_INFO) \
    $(wildcard include/config/SCHEDSTATS) \
    $(wildcard include/config/SCHED_CORE) \
    $(wildcard include/config/FAIR_GROUP_SCHED) \
    $(wildcard include/config/RT_GROUP_SCHED) \
    $(wildcard include/config/RT_MUTEXES) \
    $(wildcard include/config/UCLAMP_TASK) \
    $(wildcard include/config/UCLAMP_BUCKETS_COUNT) \
    $(wildcard include/config/KMAP_LOCAL) \
    $(wildcard include/config/THREAD_INFO_IN_TASK) \
    $(wildcard include/config/CGROUP_SCHED) \
    $(wildcard include/config/PREEMPT_NOTIFIERS) \
    $(wildcard include/config/BLK_DEV_IO_TRACE) \
    $(wildcard include/config/PREEMPT_RCU) \
    $(wildcard include/config/TASKS_RCU) \
    $(wildcard include/config/TASKS_TRACE_RCU) \
    $(wildcard include/config/MEMCG) \
    $(wildcard include/config/LRU_GEN) \
    $(wildcard include/config/COMPAT_BRK) \
    $(wildcard include/config/CGROUPS) \
    $(wildcard include/config/BLK_CGROUP) \
    $(wildcard include/config/PSI) \
    $(wildcard include/config/PAGE_OWNER) \
    $(wildcard include/config/EVENTFD) \
    $(wildcard include/config/IOMMU_SVA) \
    $(wildcard include/config/CPU_SUP_INTEL) \
    $(wildcard include/config/TASK_DELAY_ACCT) \
    $(wildcard include/config/STACKPROTECTOR) \
    $(wildcard include/config/ARCH_HAS_SCALED_CPUTIME) \
    $(wildcard include/config/VIRT_CPU_ACCOUNTING_GEN) \
    $(wildcard include/config/NO_HZ_FULL) \
    $(wildcard include/config/POSIX_CPUTIMERS) \
    $(wildcard include/config/POSIX_CPU_TIMERS_TASK_WORK) \
    $(wildcard include/config/KEYS) \
    $(wildcard include/config/SYSVIPC) \
    $(wildcard include/config/DETECT_HUNG_TASK) \
    $(wildcard include/config/IO_URING) \
    $(wildcard include/config/AUDIT) \
    $(wildcard include/config/AUDITSYSCALL) \
    $(wildcard include/config/DEBUG_MUTEXES) \
    $(wildcard include/config/TRACE_IRQFLAGS) \
    $(wildcard include/config/UBSAN) \
    $(wildcard include/config/UBSAN_TRAP) \
    $(wildcard include/config/COMPACTION) \
    $(wildcard include/config/TASK_XACCT) \
    $(wildcard include/config/CPUSETS) \
    $(wildcard include/config/X86_CPU_RESCTRL) \
    $(wildcard include/config/FUTEX) \
    $(wildcard include/config/COMPAT) \
    $(wildcard include/config/PERF_EVENTS) \
    $(wildcard include/config/DEBUG_PREEMPT) \
    $(wildcard include/config/NUMA) \
    $(wildcard include/config/NUMA_BALANCING) \
    $(wildcard include/config/RSEQ) \
    $(wildcard include/config/SCHED_MM_CID) \
    $(wildcard include/config/FAULT_INJECTION) \
    $(wildcard include/config/LATENCYTOP) \
    $(wildcard include/config/KUNIT) \
    $(wildcard include/config/FUNCTION_GRAPH_TRACER) \
    $(wildcard include/config/UPROBES) \
    $(wildcard include/config/BCACHE) \
    $(wildcard include/config/VMAP_STACK) \
    $(wildcard include/config/LIVEPATCH) \
    $(wildcard include/config/SECURITY) \
    $(wildcard include/config/BPF_SYSCALL) \
    $(wildcard include/config/GCC_PLUGIN_STACKLEAK) \
    $(wildcard include/config/X86_MCE) \
    $(wildcard include/config/KRETPROBES) \
    $(wildcard include/config/RETHOOK) \
    $(wildcard include/config/ARCH_HAS_PARANOID_L1D_FLUSH) \
    $(wildcard include/config/RV) \
    $(wildcard include/config/USER_EVENTS) \
    $(wildcard include/config/ARCH_TASK_STRUCT_ON_STACK) \
    $(wildcard include/config/PREEMPTION) \
    $(wildcard include/config/PREEMPT_NONE) \
    $(wildcard include/config/PREEMPT_VOLUNTARY) \
    $(wildcard include/config/PREEMPT) \
    $(wildcard include/config/DEBUG_RSEQ) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/sched.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/current.h \
  /home/jacob/contest/linux-6.6.1/include/linux/cache.h \
    $(wildcard include/config/ARCH_HAS_CACHE_LINE_SIZE) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cache.h \
    $(wildcard include/config/X86_L1_CACHE_SHIFT) \
    $(wildcard include/config/X86_INTERNODE_CACHE_SHIFT) \
    $(wildcard include/config/X86_VSMP) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/percpu.h \
    $(wildcard include/config/X86_64_SMP) \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/percpu.h \
    $(wildcard include/config/HAVE_SETUP_PER_CPU_AREA) \
  /home/jacob/contest/linux-6.6.1/include/linux/threads.h \
    $(wildcard include/config/BASE_SMALL) \
  /home/jacob/contest/linux-6.6.1/include/linux/percpu-defs.h \
    $(wildcard include/config/DEBUG_FORCE_WEAK_PER_CPU) \
    $(wildcard include/config/AMD_MEM_ENCRYPT) \
  /home/jacob/contest/linux-6.6.1/include/linux/pid.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rculist.h \
    $(wildcard include/config/PROVE_RCU_LIST) \
  /home/jacob/contest/linux-6.6.1/include/linux/list.h \
    $(wildcard include/config/LIST_HARDENED) \
    $(wildcard include/config/DEBUG_LIST) \
  /home/jacob/contest/linux-6.6.1/include/linux/poison.h \
    $(wildcard include/config/ILLEGAL_POINTER_VALUE) \
  /home/jacob/contest/linux-6.6.1/include/linux/rcupdate.h \
    $(wildcard include/config/TINY_RCU) \
    $(wildcard include/config/RCU_STRICT_GRACE_PERIOD) \
    $(wildcard include/config/RCU_LAZY) \
    $(wildcard include/config/TASKS_RCU_GENERIC) \
    $(wildcard include/config/RCU_STALL_COMMON) \
    $(wildcard include/config/GENERIC_ENTRY) \
    $(wildcard include/config/KVM_XFER_TO_GUEST_WORK) \
    $(wildcard include/config/RCU_NOCB_CPU) \
    $(wildcard include/config/TASKS_RUDE_RCU) \
    $(wildcard include/config/TREE_RCU) \
    $(wildcard include/config/DEBUG_OBJECTS_RCU_HEAD) \
    $(wildcard include/config/HOTPLUG_CPU) \
    $(wildcard include/config/PROVE_RCU) \
    $(wildcard include/config/ARCH_WEAK_RELEASE_ACQUIRE) \
  /home/jacob/contest/linux-6.6.1/include/linux/atomic.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/atomic.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cmpxchg.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cmpxchg_64.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/atomic64_64.h \
  /home/jacob/contest/linux-6.6.1/include/linux/atomic/atomic-arch-fallback.h \
    $(wildcard include/config/GENERIC_ATOMIC64) \
  /home/jacob/contest/linux-6.6.1/include/linux/atomic/atomic-long.h \
  /home/jacob/contest/linux-6.6.1/include/linux/atomic/atomic-instrumented.h \
  /home/jacob/contest/linux-6.6.1/include/linux/irqflags.h \
    $(wildcard include/config/IRQSOFF_TRACER) \
    $(wildcard include/config/PREEMPT_TRACER) \
    $(wildcard include/config/DEBUG_IRQFLAGS) \
    $(wildcard include/config/TRACE_IRQFLAGS_SUPPORT) \
  /home/jacob/contest/linux-6.6.1/include/linux/cleanup.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/irqflags.h \
    $(wildcard include/config/DEBUG_ENTRY) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/processor-flags.h \
    $(wildcard include/config/VM86) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/processor-flags.h \
  /home/jacob/contest/linux-6.6.1/include/linux/mem_encrypt.h \
    $(wildcard include/config/ARCH_HAS_MEM_ENCRYPT) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/mem_encrypt.h \
    $(wildcard include/config/X86_MEM_ENCRYPT) \
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
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/nospec-branch.h \
    $(wildcard include/config/CALL_THUNKS_DEBUG) \
    $(wildcard include/config/NOINSTR_VALIDATION) \
    $(wildcard include/config/CPU_SRSO) \
    $(wildcard include/config/CPU_IBPB_ENTRY) \
  /home/jacob/contest/linux-6.6.1/include/linux/static_key.h \
  /home/jacob/contest/linux-6.6.1/include/linux/objtool.h \
    $(wildcard include/config/FRAME_POINTER) \
  /home/jacob/contest/linux-6.6.1/include/linux/objtool_types.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/msr-index.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/unwind_hints.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/orc_types.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/asm-offsets.h \
  include/generated/asm-offsets.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/GEN-for-each-reg.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/segment.h \
  /home/jacob/contest/linux-6.6.1/include/linux/preempt.h \
    $(wildcard include/config/PREEMPT_COUNT) \
    $(wildcard include/config/TRACE_PREEMPT_TOGGLE) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/preempt.h \
  /home/jacob/contest/linux-6.6.1/include/linux/thread_info.h \
    $(wildcard include/config/HAVE_ARCH_WITHIN_STACK_FRAMES) \
    $(wildcard include/config/HARDENED_USERCOPY) \
    $(wildcard include/config/BUG) \
    $(wildcard include/config/SH) \
  /home/jacob/contest/linux-6.6.1/include/linux/bug.h \
    $(wildcard include/config/GENERIC_BUG) \
    $(wildcard include/config/BUG_ON_DATA_CORRUPTION) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/bug.h \
    $(wildcard include/config/DEBUG_BUGVERBOSE) \
  /home/jacob/contest/linux-6.6.1/include/linux/instrumentation.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bug.h \
    $(wildcard include/config/GENERIC_BUG_RELATIVE_POINTERS) \
  /home/jacob/contest/linux-6.6.1/include/linux/restart_block.h \
  /home/jacob/contest/linux-6.6.1/include/linux/time64.h \
  /home/jacob/contest/linux-6.6.1/include/linux/math64.h \
    $(wildcard include/config/ARCH_SUPPORTS_INT128) \
  /home/jacob/contest/linux-6.6.1/include/vdso/math64.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/time64.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/time.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/time_types.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/thread_info.h \
    $(wildcard include/config/X86_IOPL_IOPERM) \
    $(wildcard include/config/IA32_EMULATION) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page_types.h \
    $(wildcard include/config/PHYSICAL_START) \
    $(wildcard include/config/PHYSICAL_ALIGN) \
    $(wildcard include/config/DYNAMIC_PHYSICAL_MASK) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page_64_types.h \
    $(wildcard include/config/KASAN) \
    $(wildcard include/config/DYNAMIC_MEMORY_LAYOUT) \
    $(wildcard include/config/RANDOMIZE_BASE) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/kaslr.h \
    $(wildcard include/config/RANDOMIZE_MEMORY) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page_64.h \
    $(wildcard include/config/DEBUG_VIRTUAL) \
    $(wildcard include/config/X86_VSYSCALL_EMULATION) \
  /home/jacob/contest/linux-6.6.1/include/linux/range.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/memory_model.h \
    $(wildcard include/config/FLATMEM) \
    $(wildcard include/config/SPARSEMEM_VMEMMAP) \
    $(wildcard include/config/SPARSEMEM) \
  /home/jacob/contest/linux-6.6.1/include/linux/pfn.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/getorder.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cpufeature.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/processor.h \
    $(wildcard include/config/X86_VMX_FEATURE_NAMES) \
    $(wildcard include/config/X86_DEBUGCTLMSR) \
    $(wildcard include/config/CPU_SUP_AMD) \
    $(wildcard include/config/XEN) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/math_emu.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/ptrace.h \
    $(wildcard include/config/PARAVIRT) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/ptrace.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/ptrace-abi.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/paravirt_types.h \
    $(wildcard include/config/PGTABLE_LEVELS) \
    $(wildcard include/config/ZERO_CALL_USED_REGS) \
    $(wildcard include/config/PARAVIRT_DEBUG) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/desc_defs.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/pgtable_types.h \
    $(wildcard include/config/MEM_SOFT_DIRTY) \
    $(wildcard include/config/HAVE_ARCH_USERFAULTFD_WP) \
    $(wildcard include/config/PROC_FS) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/pgtable_64_types.h \
    $(wildcard include/config/DEBUG_KMAP_LOCAL_FORCE_MAP) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/sparsemem.h \
    $(wildcard include/config/NUMA_KEEP_MEMINFO) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/proto.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/ldt.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/sigcontext.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cpuid.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/msr.h \
    $(wildcard include/config/TRACEPOINTS) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cpumask.h \
  /home/jacob/contest/linux-6.6.1/include/linux/cpumask.h \
    $(wildcard include/config/FORCE_NR_CPUS) \
    $(wildcard include/config/DEBUG_PER_CPU_MAPS) \
    $(wildcard include/config/CPUMASK_OFFSTACK) \
  /home/jacob/contest/linux-6.6.1/include/linux/bitmap.h \
  /home/jacob/contest/linux-6.6.1/include/linux/find.h \
  /home/jacob/contest/linux-6.6.1/include/linux/gfp_types.h \
    $(wildcard include/config/KASAN_HW_TAGS) \
  /home/jacob/contest/linux-6.6.1/include/linux/numa.h \
    $(wildcard include/config/NODES_SHIFT) \
    $(wildcard include/config/HAVE_ARCH_NODE_DEV_GROUP) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/msr.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/shared/msr.h \
  /home/jacob/contest/linux-6.6.1/include/linux/tracepoint-defs.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/special_insns.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/fpu/types.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/vmxfeatures.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/vdso/processor.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/shstk.h \
  /home/jacob/contest/linux-6.6.1/include/linux/personality.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/personality.h \
  /home/jacob/contest/linux-6.6.1/include/linux/err.h \
  /home/jacob/contest/linux-6.6.1/include/linux/bottom_half.h \
  /home/jacob/contest/linux-6.6.1/include/linux/lockdep.h \
    $(wildcard include/config/DEBUG_LOCKING_API_SELFTESTS) \
  /home/jacob/contest/linux-6.6.1/include/linux/smp.h \
    $(wildcard include/config/UP_LATE_INIT) \
  /home/jacob/contest/linux-6.6.1/include/linux/smp_types.h \
  /home/jacob/contest/linux-6.6.1/include/linux/llist.h \
    $(wildcard include/config/ARCH_HAVE_NMI_SAFE_CMPXCHG) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/smp.h \
    $(wildcard include/config/DEBUG_NMI_SELFTEST) \
  /home/jacob/contest/linux-6.6.1/include/linux/context_tracking_irq.h \
    $(wildcard include/config/CONTEXT_TRACKING_IDLE) \
  /home/jacob/contest/linux-6.6.1/include/linux/rcutree.h \
  /home/jacob/contest/linux-6.6.1/include/linux/wait.h \
  /home/jacob/contest/linux-6.6.1/include/linux/spinlock.h \
  arch/x86/include/generated/asm/mmiowb.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/mmiowb.h \
    $(wildcard include/config/MMIOWB) \
  /home/jacob/contest/linux-6.6.1/include/linux/spinlock_types.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rwlock_types.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/spinlock.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/paravirt.h \
    $(wildcard include/config/PARAVIRT_SPINLOCKS) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/frame.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/qspinlock.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/qspinlock.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/qrwlock.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/qrwlock.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rwlock.h \
  /home/jacob/contest/linux-6.6.1/include/linux/spinlock_api_smp.h \
    $(wildcard include/config/INLINE_SPIN_LOCK) \
    $(wildcard include/config/INLINE_SPIN_LOCK_BH) \
    $(wildcard include/config/INLINE_SPIN_LOCK_IRQ) \
    $(wildcard include/config/INLINE_SPIN_LOCK_IRQSAVE) \
    $(wildcard include/config/INLINE_SPIN_TRYLOCK) \
    $(wildcard include/config/INLINE_SPIN_TRYLOCK_BH) \
    $(wildcard include/config/UNINLINE_SPIN_UNLOCK) \
    $(wildcard include/config/INLINE_SPIN_UNLOCK_BH) \
    $(wildcard include/config/INLINE_SPIN_UNLOCK_IRQ) \
    $(wildcard include/config/INLINE_SPIN_UNLOCK_IRQRESTORE) \
    $(wildcard include/config/GENERIC_LOCKBREAK) \
  /home/jacob/contest/linux-6.6.1/include/linux/rwlock_api_smp.h \
    $(wildcard include/config/INLINE_READ_LOCK) \
    $(wildcard include/config/INLINE_WRITE_LOCK) \
    $(wildcard include/config/INLINE_READ_LOCK_BH) \
    $(wildcard include/config/INLINE_WRITE_LOCK_BH) \
    $(wildcard include/config/INLINE_READ_LOCK_IRQ) \
    $(wildcard include/config/INLINE_WRITE_LOCK_IRQ) \
    $(wildcard include/config/INLINE_READ_LOCK_IRQSAVE) \
    $(wildcard include/config/INLINE_WRITE_LOCK_IRQSAVE) \
    $(wildcard include/config/INLINE_READ_TRYLOCK) \
    $(wildcard include/config/INLINE_WRITE_TRYLOCK) \
    $(wildcard include/config/INLINE_READ_UNLOCK) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK) \
    $(wildcard include/config/INLINE_READ_UNLOCK_BH) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK_BH) \
    $(wildcard include/config/INLINE_READ_UNLOCK_IRQ) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK_IRQ) \
    $(wildcard include/config/INLINE_READ_UNLOCK_IRQRESTORE) \
    $(wildcard include/config/INLINE_WRITE_UNLOCK_IRQRESTORE) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/wait.h \
  /home/jacob/contest/linux-6.6.1/include/linux/refcount.h \
  /home/jacob/contest/linux-6.6.1/include/linux/sem.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/sem.h \
  /home/jacob/contest/linux-6.6.1/include/linux/ipc.h \
  /home/jacob/contest/linux-6.6.1/include/linux/uidgid.h \
    $(wildcard include/config/MULTIUSER) \
    $(wildcard include/config/USER_NS) \
  /home/jacob/contest/linux-6.6.1/include/linux/highuid.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rhashtable-types.h \
  /home/jacob/contest/linux-6.6.1/include/linux/mutex.h \
    $(wildcard include/config/MUTEX_SPIN_ON_OWNER) \
  /home/jacob/contest/linux-6.6.1/include/linux/osq_lock.h \
  /home/jacob/contest/linux-6.6.1/include/linux/debug_locks.h \
  /home/jacob/contest/linux-6.6.1/include/linux/workqueue.h \
    $(wildcard include/config/DEBUG_OBJECTS_WORK) \
    $(wildcard include/config/FREEZER) \
    $(wildcard include/config/SYSFS) \
    $(wildcard include/config/WQ_WATCHDOG) \
  /home/jacob/contest/linux-6.6.1/include/linux/timer.h \
    $(wildcard include/config/DEBUG_OBJECTS_TIMERS) \
  /home/jacob/contest/linux-6.6.1/include/linux/ktime.h \
  /home/jacob/contest/linux-6.6.1/include/linux/time.h \
    $(wildcard include/config/POSIX_TIMERS) \
  /home/jacob/contest/linux-6.6.1/include/linux/time32.h \
  /home/jacob/contest/linux-6.6.1/include/linux/timex.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/timex.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/timex.h \
    $(wildcard include/config/X86_TSC) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/tsc.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/time32.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/time.h \
  /home/jacob/contest/linux-6.6.1/include/linux/jiffies.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/jiffies.h \
  include/generated/timeconst.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/ktime.h \
  /home/jacob/contest/linux-6.6.1/include/linux/timekeeping.h \
    $(wildcard include/config/GENERIC_CMOS_UPDATE) \
  /home/jacob/contest/linux-6.6.1/include/linux/clocksource_ids.h \
  /home/jacob/contest/linux-6.6.1/include/linux/debugobjects.h \
    $(wildcard include/config/DEBUG_OBJECTS) \
    $(wildcard include/config/DEBUG_OBJECTS_FREE) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/ipc.h \
  arch/x86/include/generated/uapi/asm/ipcbuf.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/ipcbuf.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/sembuf.h \
  /home/jacob/contest/linux-6.6.1/include/linux/shm.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/shm.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/hugetlb_encode.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/shmbuf.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/shmbuf.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/shmparam.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kmsan_types.h \
  /home/jacob/contest/linux-6.6.1/include/linux/plist.h \
    $(wildcard include/config/DEBUG_PLIST) \
  /home/jacob/contest/linux-6.6.1/include/linux/hrtimer.h \
    $(wildcard include/config/HIGH_RES_TIMERS) \
    $(wildcard include/config/TIME_LOW_RES) \
    $(wildcard include/config/TIMERFD) \
  /home/jacob/contest/linux-6.6.1/include/linux/hrtimer_defs.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rbtree.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rbtree_types.h \
  /home/jacob/contest/linux-6.6.1/include/linux/percpu.h \
    $(wildcard include/config/MODULES) \
    $(wildcard include/config/RANDOM_KMALLOC_CACHES) \
    $(wildcard include/config/NEED_PER_CPU_PAGE_FIRST_CHUNK) \
  /home/jacob/contest/linux-6.6.1/include/linux/mmdebug.h \
    $(wildcard include/config/DEBUG_VM) \
    $(wildcard include/config/DEBUG_VM_IRQSOFF) \
    $(wildcard include/config/DEBUG_VM_PGFLAGS) \
  /home/jacob/contest/linux-6.6.1/include/linux/seqlock.h \
  /home/jacob/contest/linux-6.6.1/include/linux/timerqueue.h \
  /home/jacob/contest/linux-6.6.1/include/linux/seccomp.h \
    $(wildcard include/config/SECCOMP) \
    $(wildcard include/config/HAVE_ARCH_SECCOMP_FILTER) \
    $(wildcard include/config/SECCOMP_FILTER) \
    $(wildcard include/config/CHECKPOINT_RESTORE) \
    $(wildcard include/config/SECCOMP_CACHE_DEBUG) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/seccomp.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/seccomp.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/unistd.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/unistd.h \
  arch/x86/include/generated/uapi/asm/unistd_64.h \
  arch/x86/include/generated/asm/unistd_64_x32.h \
  arch/x86/include/generated/asm/unistd_32_ia32.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/ia32_unistd.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/seccomp.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/unistd.h \
  /home/jacob/contest/linux-6.6.1/include/linux/nodemask.h \
    $(wildcard include/config/HIGHMEM) \
  /home/jacob/contest/linux-6.6.1/include/linux/random.h \
    $(wildcard include/config/VMGENID) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/random.h \
  /home/jacob/contest/linux-6.6.1/include/linux/irqnr.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/irqnr.h \
  /home/jacob/contest/linux-6.6.1/include/linux/prandom.h \
  /home/jacob/contest/linux-6.6.1/include/linux/once.h \
  /home/jacob/contest/linux-6.6.1/include/linux/resource.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/resource.h \
  arch/x86/include/generated/uapi/asm/resource.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/resource.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/resource.h \
  /home/jacob/contest/linux-6.6.1/include/linux/latencytop.h \
  /home/jacob/contest/linux-6.6.1/include/linux/sched/prio.h \
  /home/jacob/contest/linux-6.6.1/include/linux/sched/types.h \
  /home/jacob/contest/linux-6.6.1/include/linux/signal_types.h \
    $(wildcard include/config/OLD_SIGACTION) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/signal.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/signal.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/signal.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/signal-defs.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/siginfo.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/siginfo.h \
  /home/jacob/contest/linux-6.6.1/include/linux/syscall_user_dispatch.h \
  /home/jacob/contest/linux-6.6.1/include/linux/mm_types_task.h \
    $(wildcard include/config/ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH) \
    $(wildcard include/config/SPLIT_PTLOCK_CPUS) \
    $(wildcard include/config/ARCH_ENABLE_SPLIT_PMD_PTLOCK) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/tlbbatch.h \
  /home/jacob/contest/linux-6.6.1/include/linux/task_io_accounting.h \
    $(wildcard include/config/TASK_IO_ACCOUNTING) \
  /home/jacob/contest/linux-6.6.1/include/linux/posix-timers.h \
  /home/jacob/contest/linux-6.6.1/include/linux/alarmtimer.h \
    $(wildcard include/config/RTC_CLASS) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/rseq.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kcsan.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rv.h \
    $(wildcard include/config/RV_REACTORS) \
  /home/jacob/contest/linux-6.6.1/include/linux/livepatch_sched.h \
  arch/x86/include/generated/asm/kmap_size.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/kmap_size.h \
    $(wildcard include/config/DEBUG_KMAP_LOCAL) \
  /home/jacob/contest/linux-6.6.1/include/linux/slab.h \
    $(wildcard include/config/DEBUG_SLAB) \
    $(wildcard include/config/SLUB_TINY) \
    $(wildcard include/config/FAILSLAB) \
    $(wildcard include/config/MEMCG_KMEM) \
    $(wildcard include/config/KFENCE) \
    $(wildcard include/config/SLAB) \
    $(wildcard include/config/SLUB) \
    $(wildcard include/config/ZONE_DMA) \
  /home/jacob/contest/linux-6.6.1/include/linux/gfp.h \
    $(wildcard include/config/ZONE_DMA32) \
    $(wildcard include/config/ZONE_DEVICE) \
    $(wildcard include/config/CONTIG_ALLOC) \
  /home/jacob/contest/linux-6.6.1/include/linux/mmzone.h \
    $(wildcard include/config/ARCH_FORCE_MAX_ORDER) \
    $(wildcard include/config/CMA) \
    $(wildcard include/config/MEMORY_ISOLATION) \
    $(wildcard include/config/ZSMALLOC) \
    $(wildcard include/config/UNACCEPTED_MEMORY) \
    $(wildcard include/config/SWAP) \
    $(wildcard include/config/TRANSPARENT_HUGEPAGE) \
    $(wildcard include/config/LRU_GEN_STATS) \
    $(wildcard include/config/MEMORY_HOTPLUG) \
    $(wildcard include/config/MEMORY_FAILURE) \
    $(wildcard include/config/PAGE_EXTENSION) \
    $(wildcard include/config/DEFERRED_STRUCT_PAGE_INIT) \
    $(wildcard include/config/HAVE_MEMORYLESS_NODES) \
    $(wildcard include/config/SPARSEMEM_EXTREME) \
    $(wildcard include/config/HAVE_ARCH_PFN_VALID) \
  /home/jacob/contest/linux-6.6.1/include/linux/list_nulls.h \
  /home/jacob/contest/linux-6.6.1/include/linux/pageblock-flags.h \
    $(wildcard include/config/HUGETLB_PAGE) \
    $(wildcard include/config/HUGETLB_PAGE_SIZE_VARIABLE) \
  /home/jacob/contest/linux-6.6.1/include/linux/page-flags-layout.h \
  include/generated/bounds.h \
  /home/jacob/contest/linux-6.6.1/include/linux/mm_types.h \
    $(wildcard include/config/HAVE_ALIGNED_STRUCT_PAGE) \
    $(wildcard include/config/USERFAULTFD) \
    $(wildcard include/config/PER_VMA_LOCK) \
    $(wildcard include/config/ANON_VMA_NAME) \
    $(wildcard include/config/HAVE_ARCH_COMPAT_MMAP_BASES) \
    $(wildcard include/config/MEMBARRIER) \
    $(wildcard include/config/AIO) \
    $(wildcard include/config/MMU_NOTIFIER) \
    $(wildcard include/config/KSM) \
  /home/jacob/contest/linux-6.6.1/include/linux/auxvec.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/auxvec.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/auxvec.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kref.h \
  /home/jacob/contest/linux-6.6.1/include/linux/maple_tree.h \
    $(wildcard include/config/MAPLE_RCU_DISABLED) \
    $(wildcard include/config/DEBUG_MAPLE_TREE) \
  /home/jacob/contest/linux-6.6.1/include/linux/rwsem.h \
    $(wildcard include/config/RWSEM_SPIN_ON_OWNER) \
    $(wildcard include/config/DEBUG_RWSEMS) \
  /home/jacob/contest/linux-6.6.1/include/linux/completion.h \
  /home/jacob/contest/linux-6.6.1/include/linux/swait.h \
  /home/jacob/contest/linux-6.6.1/include/linux/uprobes.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/uprobes.h \
  /home/jacob/contest/linux-6.6.1/include/linux/notifier.h \
    $(wildcard include/config/TREE_SRCU) \
  /home/jacob/contest/linux-6.6.1/include/linux/srcu.h \
    $(wildcard include/config/TINY_SRCU) \
    $(wildcard include/config/NEED_SRCU_NMI_SAFE) \
  /home/jacob/contest/linux-6.6.1/include/linux/rcu_segcblist.h \
  /home/jacob/contest/linux-6.6.1/include/linux/srcutree.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rcu_node_tree.h \
    $(wildcard include/config/RCU_FANOUT) \
    $(wildcard include/config/RCU_FANOUT_LEAF) \
  /home/jacob/contest/linux-6.6.1/include/linux/percpu_counter.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/mmu.h \
    $(wildcard include/config/MODIFY_LDT_SYSCALL) \
  /home/jacob/contest/linux-6.6.1/include/linux/page-flags.h \
    $(wildcard include/config/ARCH_USES_PG_UNCACHED) \
    $(wildcard include/config/PAGE_IDLE_FLAG) \
    $(wildcard include/config/ARCH_USES_PG_ARCH_X) \
    $(wildcard include/config/HUGETLB_PAGE_OPTIMIZE_VMEMMAP) \
  /home/jacob/contest/linux-6.6.1/include/linux/local_lock.h \
  /home/jacob/contest/linux-6.6.1/include/linux/local_lock_internal.h \
  /home/jacob/contest/linux-6.6.1/include/linux/memory_hotplug.h \
    $(wildcard include/config/HAVE_ARCH_NODEDATA_EXTENSION) \
    $(wildcard include/config/ARCH_HAS_ADD_PAGES) \
    $(wildcard include/config/MEMORY_HOTREMOVE) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/mmzone.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/mmzone_64.h \
  /home/jacob/contest/linux-6.6.1/include/linux/topology.h \
    $(wildcard include/config/USE_PERCPU_NUMA_NODE_ID) \
    $(wildcard include/config/SCHED_SMT) \
  /home/jacob/contest/linux-6.6.1/include/linux/arch_topology.h \
    $(wildcard include/config/ACPI_CPPC_LIB) \
    $(wildcard include/config/GENERIC_ARCH_TOPOLOGY) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/topology.h \
    $(wildcard include/config/SCHED_MC_PRIO) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/mpspec.h \
    $(wildcard include/config/EISA) \
    $(wildcard include/config/X86_LOCAL_APIC) \
    $(wildcard include/config/X86_MPPARSE) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/mpspec_def.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/x86_init.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/apicdef.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/topology.h \
  /home/jacob/contest/linux-6.6.1/include/linux/cpu_smt.h \
    $(wildcard include/config/HOTPLUG_SMT) \
  /home/jacob/contest/linux-6.6.1/include/linux/overflow.h \
  /home/jacob/contest/linux-6.6.1/include/linux/percpu-refcount.h \
  /home/jacob/contest/linux-6.6.1/include/linux/hash.h \
    $(wildcard include/config/HAVE_ARCH_HASH) \
  /home/jacob/contest/linux-6.6.1/include/linux/kasan.h \
    $(wildcard include/config/KASAN_STACK) \
    $(wildcard include/config/KASAN_VMALLOC) \
  /home/jacob/contest/linux-6.6.1/include/linux/kasan-enabled.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/acenv.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/acnames.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/actypes.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/acexcep.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/actbl.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/actbl1.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/actbl2.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/actbl3.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/acrestyp.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/platform/acenvex.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/platform/aclinuxex.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/platform/acgccex.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/acoutput.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/acpiosxf.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/acpixf.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/acconfig.h \
  /home/jacob/contest/linux-6.6.1/include/acpi/acbuffer.h \
  /home/jacob/contest/linux-6.6.1/drivers/acpi/acpica/accommon.h \
  /home/jacob/contest/linux-6.6.1/drivers/acpi/acpica/acmacros.h \
  /home/jacob/contest/linux-6.6.1/drivers/acpi/acpica/aclocal.h \
  /home/jacob/contest/linux-6.6.1/drivers/acpi/acpica/acobject.h \
  /home/jacob/contest/linux-6.6.1/drivers/acpi/acpica/acstruct.h \
  /home/jacob/contest/linux-6.6.1/drivers/acpi/acpica/acglobal.h \
  /home/jacob/contest/linux-6.6.1/drivers/acpi/acpica/achware.h \
  /home/jacob/contest/linux-6.6.1/drivers/acpi/acpica/acutils.h \

drivers/acpi/acpica/utascii.o: $(deps_drivers/acpi/acpica/utascii.o)

$(deps_drivers/acpi/acpica/utascii.o):
