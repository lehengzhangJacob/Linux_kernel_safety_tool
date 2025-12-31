savedcmd_arch/x86/entry/entry_64.o := gcc -Wp,-MMD,arch/x86/entry/.entry_64.o.d -nostdinc -I/home/jacob/contest/linux-6.6.1/arch/x86/include -I./arch/x86/include/generated -I/home/jacob/contest/linux-6.6.1/include -I./include -I/home/jacob/contest/linux-6.6.1/arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I/home/jacob/contest/linux-6.6.1/include/uapi -I./include/generated/uapi -include /home/jacob/contest/linux-6.6.1/include/linux/compiler-version.h -include /home/jacob/contest/linux-6.6.1/include/linux/kconfig.h -D__KERNEL__ -fmacro-prefix-map=/home/jacob/contest/linux-6.6.1/= -Werror -D__ASSEMBLY__ -fno-PIE -m64 -I /home/jacob/contest/linux-6.6.1/arch/x86/entry -I ./arch/x86/entry    -c -o arch/x86/entry/entry_64.o /home/jacob/contest/linux-6.6.1/arch/x86/entry/entry_64.S 

source_arch/x86/entry/entry_64.o := /home/jacob/contest/linux-6.6.1/arch/x86/entry/entry_64.S

deps_arch/x86/entry/entry_64.o := \
    $(wildcard include/config/X86_5LEVEL) \
    $(wildcard include/config/STACKPROTECTOR) \
    $(wildcard include/config/DEBUG_ENTRY) \
    $(wildcard include/config/X86_L1_CACHE_SHIFT) \
    $(wildcard include/config/AMD_MEM_ENCRYPT) \
    $(wildcard include/config/XEN_PV) \
    $(wildcard include/config/X86_ESPFIX64) \
    $(wildcard include/config/IA32_EMULATION) \
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
    $(wildcard include/config/64BIT) \
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
  /home/jacob/contest/linux-6.6.1/include/linux/const.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/const.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/const.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/alternative.h \
    $(wildcard include/config/CALL_THUNKS) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/asm.h \
    $(wildcard include/config/KPROBES) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/extable_fixup_types.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cache.h \
    $(wildcard include/config/X86_INTERNODE_CACHE_SHIFT) \
    $(wildcard include/config/X86_VSMP) \
  arch/x86/include/generated/uapi/asm/errno.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/errno.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/errno-base.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/asm-offsets.h \
  include/generated/asm-offsets.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/msr.h \
    $(wildcard include/config/TRACEPOINTS) \
    $(wildcard include/config/PARAVIRT_XXL) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/msr-index.h \
  /home/jacob/contest/linux-6.6.1/include/linux/bits.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/bits.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/unistd.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/unistd.h \
  arch/x86/include/generated/uapi/asm/unistd_64.h \
  arch/x86/include/generated/asm/unistd_64_x32.h \
  arch/x86/include/generated/asm/unistd_32_ia32.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/thread_info.h \
    $(wildcard include/config/VM86) \
    $(wildcard include/config/X86_IOPL_IOPERM) \
    $(wildcard include/config/FRAME_POINTER) \
    $(wildcard include/config/COMPAT) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page_types.h \
    $(wildcard include/config/PHYSICAL_START) \
    $(wildcard include/config/PHYSICAL_ALIGN) \
    $(wildcard include/config/DYNAMIC_PHYSICAL_MASK) \
  /home/jacob/contest/linux-6.6.1/include/linux/mem_encrypt.h \
    $(wildcard include/config/ARCH_HAS_MEM_ENCRYPT) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page_64_types.h \
    $(wildcard include/config/KASAN) \
    $(wildcard include/config/DYNAMIC_MEMORY_LAYOUT) \
    $(wildcard include/config/RANDOMIZE_BASE) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/page_64.h \
    $(wildcard include/config/DEBUG_VIRTUAL) \
    $(wildcard include/config/X86_VSYSCALL_EMULATION) \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/memory_model.h \
    $(wildcard include/config/FLATMEM) \
    $(wildcard include/config/SPARSEMEM_VMEMMAP) \
    $(wildcard include/config/SPARSEMEM) \
  /home/jacob/contest/linux-6.6.1/include/linux/pfn.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/getorder.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/percpu.h \
    $(wildcard include/config/X86_64_SMP) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/hw_irq.h \
    $(wildcard include/config/X86_LOCAL_APIC) \
    $(wildcard include/config/TRACING) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/irq_vectors.h \
    $(wildcard include/config/HAVE_KVM) \
    $(wildcard include/config/HYPERV) \
    $(wildcard include/config/X86_IO_APIC) \
    $(wildcard include/config/PCI_MSI) \
  /home/jacob/contest/linux-6.6.1/include/linux/threads.h \
    $(wildcard include/config/NR_CPUS) \
    $(wildcard include/config/BASE_SMALL) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/irqflags.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/processor-flags.h \
    $(wildcard include/config/PAGE_TABLE_ISOLATION) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/processor-flags.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/paravirt.h \
    $(wildcard include/config/PARAVIRT) \
    $(wildcard include/config/PARAVIRT_SPINLOCKS) \
    $(wildcard include/config/PGTABLE_LEVELS) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/paravirt_types.h \
    $(wildcard include/config/ZERO_CALL_USED_REGS) \
    $(wildcard include/config/PARAVIRT_DEBUG) \
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
    $(wildcard include/config/X86_SGX) \
    $(wildcard include/config/INTEL_TDX_GUEST) \
    $(wildcard include/config/X86_USER_SHADOW_STACK) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/unwind_hints.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/orc_types.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/current.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/smap.h \
  arch/x86/include/generated/asm/export.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/export.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/frame.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/trapnr.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/fsgsbase.h \
  /home/jacob/contest/linux-6.6.1/include/linux/err.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/entry/calling.h \
    $(wildcard include/config/CPU_IBRS_ENTRY) \
    $(wildcard include/config/GCC_PLUGIN_STACKLEAK) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/ptrace-abi.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/idtentry.h \
    $(wildcard include/config/X86_MCE) \
    $(wildcard include/config/KVM_INTEL) \
    $(wildcard include/config/X86_CET) \
    $(wildcard include/config/X86_MCE_THRESHOLD) \
    $(wildcard include/config/X86_MCE_AMD) \
    $(wildcard include/config/X86_THERMAL_VECTOR) \
    $(wildcard include/config/IRQ_WORK) \
    $(wildcard include/config/ACRN_GUEST) \
    $(wildcard include/config/XEN_PVHVM) \
    $(wildcard include/config/KVM_GUEST) \

arch/x86/entry/entry_64.o: $(deps_arch/x86/entry/entry_64.o)

$(deps_arch/x86/entry/entry_64.o):
