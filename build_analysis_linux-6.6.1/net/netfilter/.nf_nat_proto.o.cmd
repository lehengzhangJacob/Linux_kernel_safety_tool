savedcmd_net/netfilter/nf_nat_proto.o := gcc -Wp,-MMD,net/netfilter/.nf_nat_proto.o.d -nostdinc -I/home/jacob/contest/linux-6.6.1/arch/x86/include -I./arch/x86/include/generated -I/home/jacob/contest/linux-6.6.1/include -I./include -I/home/jacob/contest/linux-6.6.1/arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I/home/jacob/contest/linux-6.6.1/include/uapi -I./include/generated/uapi -include /home/jacob/contest/linux-6.6.1/include/linux/compiler-version.h -include /home/jacob/contest/linux-6.6.1/include/linux/kconfig.h -include /home/jacob/contest/linux-6.6.1/include/linux/compiler_types.h -D__KERNEL__ -fmacro-prefix-map=/home/jacob/contest/linux-6.6.1/= -Werror -std=gnu11 -fshort-wchar -funsigned-char -fno-common -fno-PIE -fno-strict-aliasing -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -fcf-protection=branch -fno-jump-tables -m64 -falign-jumps=1 -falign-loops=1 -mno-80387 -mno-fp-ret-in-387 -mpreferred-stack-boundary=3 -mskip-rax-setup -mtune=generic -mno-red-zone -mcmodel=kernel -Wno-sign-compare -fno-asynchronous-unwind-tables -mindirect-branch=thunk-extern -mindirect-branch-register -mindirect-branch-cs-prefix -mfunction-return=thunk-extern -fno-jump-tables -fpatchable-function-entry=16,16 -fno-delete-null-pointer-checks -O2 -fno-allow-store-data-races -fstack-protector-strong -fomit-frame-pointer -ftrivial-auto-var-init=zero -fno-stack-clash-protection -falign-functions=16 -fstrict-flex-arrays=3 -fno-strict-overflow -fno-stack-check -fconserve-stack -Wall -Wundef -Werror=implicit-function-declaration -Werror=implicit-int -Werror=return-type -Werror=strict-prototypes -Wno-format-security -Wno-trigraphs -Wno-frame-address -Wno-address-of-packed-member -Wframe-larger-than=2048 -Wno-main -Wno-unused-but-set-variable -Wno-unused-const-variable -Wno-dangling-pointer -Wvla -Wno-pointer-sign -Wcast-function-type -Wno-array-bounds -Wno-alloc-size-larger-than -Wimplicit-fallthrough=5 -Werror=date-time -Werror=incompatible-pointer-types -Werror=designated-init -Wenum-conversion -Wno-unused-but-set-variable -Wno-unused-const-variable -Wno-restrict -Wno-packed-not-aligned -Wno-format-overflow -Wno-format-truncation -Wno-stringop-overflow -Wno-stringop-truncation -Wno-missing-field-initializers -Wno-type-limits -Wno-shift-negative-value -Wno-maybe-uninitialized -Wno-sign-compare -fplugin=/home/jacob/contest/src/plugin/analyzer_plugin.so -I /home/jacob/contest/linux-6.6.1/net/netfilter -I ./net/netfilter    -DKBUILD_MODFILE='"net/netfilter/nf_nat"' -DKBUILD_BASENAME='"nf_nat_proto"' -DKBUILD_MODNAME='"nf_nat"' -D__KBUILD_MODNAME=kmod_nf_nat -c -o net/netfilter/nf_nat_proto.o /home/jacob/contest/linux-6.6.1/net/netfilter/nf_nat_proto.c  

source_net/netfilter/nf_nat_proto.o := /home/jacob/contest/linux-6.6.1/net/netfilter/nf_nat_proto.c

deps_net/netfilter/nf_nat_proto.o := \
    $(wildcard include/config/NF_CT_PROTO_UDPLITE) \
    $(wildcard include/config/NF_CT_PROTO_SCTP) \
    $(wildcard include/config/NF_CT_PROTO_DCCP) \
    $(wildcard include/config/NF_CT_PROTO_GRE) \
    $(wildcard include/config/IPV6) \
    $(wildcard include/config/XFRM) \
    $(wildcard include/config/NF_TABLES_INET) \
    $(wildcard include/config/NFT_NAT) \
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
  /home/jacob/contest/linux-6.6.1/include/linux/export.h \
    $(wildcard include/config/MODVERSIONS) \
  /home/jacob/contest/linux-6.6.1/include/linux/compiler.h \
    $(wildcard include/config/TRACE_BRANCH_PROFILING) \
    $(wildcard include/config/PROFILE_ALL_BRANCHES) \
    $(wildcard include/config/OBJTOOL) \
  arch/x86/include/generated/asm/rwonce.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/rwonce.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kasan-checks.h \
    $(wildcard include/config/KASAN_GENERIC) \
    $(wildcard include/config/KASAN_SW_TAGS) \
  /home/jacob/contest/linux-6.6.1/include/linux/kcsan-checks.h \
    $(wildcard include/config/KCSAN) \
    $(wildcard include/config/KCSAN_WEAK_MEMORY) \
    $(wildcard include/config/KCSAN_IGNORE_ATOMICS) \
  /home/jacob/contest/linux-6.6.1/include/linux/linkage.h \
    $(wildcard include/config/ARCH_USE_SYM_ANNOTATIONS) \
  /home/jacob/contest/linux-6.6.1/include/linux/stringify.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/linkage.h \
    $(wildcard include/config/CALL_PADDING) \
    $(wildcard include/config/RETHUNK) \
    $(wildcard include/config/SLS) \
    $(wildcard include/config/FUNCTION_PADDING_BYTES) \
    $(wildcard include/config/UML) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/ibt.h \
    $(wildcard include/config/X86_KERNEL_IBT) \
  /home/jacob/contest/linux-6.6.1/include/linux/init.h \
    $(wildcard include/config/HAVE_ARCH_PREL32_RELOCATIONS) \
    $(wildcard include/config/STRICT_KERNEL_RWX) \
    $(wildcard include/config/STRICT_MODULE_RWX) \
    $(wildcard include/config/LTO_CLANG) \
  /home/jacob/contest/linux-6.6.1/include/linux/build_bug.h \
  /home/jacob/contest/linux-6.6.1/include/linux/udp.h \
    $(wildcard include/config/BASE_SMALL) \
  /home/jacob/contest/linux-6.6.1/include/net/inet_sock.h \
    $(wildcard include/config/NET_L3_MASTER_DEV) \
    $(wildcard include/config/INET) \
  /home/jacob/contest/linux-6.6.1/include/linux/bitops.h \
  /home/jacob/contest/linux-6.6.1/include/linux/bits.h \
  /home/jacob/contest/linux-6.6.1/include/linux/const.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/const.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/const.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/bits.h \
  /home/jacob/contest/linux-6.6.1/include/linux/typecheck.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/kernel.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/sysinfo.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/bitops/generic-non-atomic.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/barrier.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/alternative.h \
    $(wildcard include/config/SMP) \
    $(wildcard include/config/CALL_THUNKS) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/asm.h \
    $(wildcard include/config/KPROBES) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/extable_fixup_types.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/nops.h \
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
    $(wildcard include/config/KMSAN) \
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
  /home/jacob/contest/linux-6.6.1/include/linux/string.h \
    $(wildcard include/config/BINARY_PRINTF) \
    $(wildcard include/config/FORTIFY_SOURCE) \
  /home/jacob/contest/linux-6.6.1/include/linux/errno.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/errno.h \
  arch/x86/include/generated/uapi/asm/errno.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/errno.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/errno-base.h \
  /home/jacob/contest/linux-6.6.1/include/linux/stdarg.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/string.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/string.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/string_64.h \
    $(wildcard include/config/ARCH_HAS_UACCESS_FLUSHCACHE) \
  /home/jacob/contest/linux-6.6.1/include/linux/jump_label.h \
    $(wildcard include/config/JUMP_LABEL) \
    $(wildcard include/config/HAVE_ARCH_JUMP_LABEL_RELATIVE) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/jump_label.h \
    $(wildcard include/config/HAVE_JUMP_LABEL_HACK) \
  /home/jacob/contest/linux-6.6.1/include/linux/jhash.h \
  /home/jacob/contest/linux-6.6.1/include/linux/unaligned/packed_struct.h \
  /home/jacob/contest/linux-6.6.1/include/linux/netdevice.h \
    $(wildcard include/config/DCB) \
    $(wildcard include/config/HYPERV_NET) \
    $(wildcard include/config/WLAN) \
    $(wildcard include/config/AX25) \
    $(wildcard include/config/MAC80211_MESH) \
    $(wildcard include/config/NET_IPIP) \
    $(wildcard include/config/NET_IPGRE) \
    $(wildcard include/config/IPV6_SIT) \
    $(wildcard include/config/IPV6_TUNNEL) \
    $(wildcard include/config/RPS) \
    $(wildcard include/config/NETPOLL) \
    $(wildcard include/config/SYSFS) \
    $(wildcard include/config/XPS) \
    $(wildcard include/config/NUMA) \
    $(wildcard include/config/XDP_SOCKETS) \
    $(wildcard include/config/BQL) \
    $(wildcard include/config/SYSCTL) \
    $(wildcard include/config/RFS_ACCEL) \
    $(wildcard include/config/FCOE) \
    $(wildcard include/config/XFRM_OFFLOAD) \
    $(wildcard include/config/NET_POLL_CONTROLLER) \
    $(wildcard include/config/LIBFCOE) \
    $(wildcard include/config/WIRELESS_EXT) \
    $(wildcard include/config/TLS_DEVICE) \
    $(wildcard include/config/LOCKDEP) \
    $(wildcard include/config/VLAN_8021Q) \
    $(wildcard include/config/NET_DSA) \
    $(wildcard include/config/TIPC) \
    $(wildcard include/config/ATALK) \
    $(wildcard include/config/CFG80211) \
    $(wildcard include/config/IEEE802154) \
    $(wildcard include/config/6LOWPAN) \
    $(wildcard include/config/MPLS_ROUTING) \
    $(wildcard include/config/MCTP) \
    $(wildcard include/config/NET_XGRESS) \
    $(wildcard include/config/NETFILTER_INGRESS) \
    $(wildcard include/config/NETFILTER_EGRESS) \
    $(wildcard include/config/NET_SCHED) \
    $(wildcard include/config/PCPU_DEV_REFCNT) \
    $(wildcard include/config/GARP) \
    $(wildcard include/config/MRP) \
    $(wildcard include/config/NET_DROP_MONITOR) \
    $(wildcard include/config/CGROUP_NET_PRIO) \
    $(wildcard include/config/MACSEC) \
    $(wildcard include/config/NET_FLOW_LIMIT) \
    $(wildcard include/config/NET_EGRESS) \
    $(wildcard include/config/NET_DEV_REFCNT_TRACKER) \
    $(wildcard include/config/ETHTOOL_NETLINK) \
    $(wildcard include/config/BUG) \
  /home/jacob/contest/linux-6.6.1/include/linux/timer.h \
    $(wildcard include/config/DEBUG_OBJECTS_TIMERS) \
    $(wildcard include/config/HOTPLUG_CPU) \
  /home/jacob/contest/linux-6.6.1/include/linux/list.h \
    $(wildcard include/config/LIST_HARDENED) \
    $(wildcard include/config/DEBUG_LIST) \
  /home/jacob/contest/linux-6.6.1/include/linux/container_of.h \
  /home/jacob/contest/linux-6.6.1/include/linux/poison.h \
    $(wildcard include/config/ILLEGAL_POINTER_VALUE) \
  /home/jacob/contest/linux-6.6.1/include/linux/ktime.h \
  /home/jacob/contest/linux-6.6.1/include/linux/time.h \
    $(wildcard include/config/POSIX_TIMERS) \
  /home/jacob/contest/linux-6.6.1/include/linux/cache.h \
    $(wildcard include/config/ARCH_HAS_CACHE_LINE_SIZE) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cache.h \
    $(wildcard include/config/X86_L1_CACHE_SHIFT) \
    $(wildcard include/config/X86_INTERNODE_CACHE_SHIFT) \
    $(wildcard include/config/X86_VSMP) \
  /home/jacob/contest/linux-6.6.1/include/linux/math64.h \
    $(wildcard include/config/ARCH_SUPPORTS_INT128) \
  /home/jacob/contest/linux-6.6.1/include/linux/math.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/div64.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/div64.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/math64.h \
  /home/jacob/contest/linux-6.6.1/include/linux/time64.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/time64.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/time.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/time_types.h \
  /home/jacob/contest/linux-6.6.1/include/linux/time32.h \
  /home/jacob/contest/linux-6.6.1/include/linux/timex.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/timex.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/param.h \
  arch/x86/include/generated/uapi/asm/param.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/param.h \
    $(wildcard include/config/HZ) \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/param.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/timex.h \
    $(wildcard include/config/X86_TSC) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/processor.h \
    $(wildcard include/config/X86_VMX_FEATURE_NAMES) \
    $(wildcard include/config/X86_IOPL_IOPERM) \
    $(wildcard include/config/STACKPROTECTOR) \
    $(wildcard include/config/VM86) \
    $(wildcard include/config/X86_DEBUGCTLMSR) \
    $(wildcard include/config/CPU_SUP_AMD) \
    $(wildcard include/config/XEN) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/processor-flags.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/processor-flags.h \
  /home/jacob/contest/linux-6.6.1/include/linux/mem_encrypt.h \
    $(wildcard include/config/ARCH_HAS_MEM_ENCRYPT) \
    $(wildcard include/config/AMD_MEM_ENCRYPT) \
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
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/math_emu.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/ptrace.h \
    $(wildcard include/config/PARAVIRT) \
    $(wildcard include/config/IA32_EMULATION) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/segment.h \
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
    $(wildcard include/config/SPARSEMEM) \
    $(wildcard include/config/NUMA_KEEP_MEMINFO) \
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
  /home/jacob/contest/linux-6.6.1/include/linux/align.h \
  /home/jacob/contest/linux-6.6.1/include/linux/limits.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/limits.h \
  /home/jacob/contest/linux-6.6.1/include/vdso/limits.h \
  /home/jacob/contest/linux-6.6.1/include/linux/hex.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kstrtox.h \
  /home/jacob/contest/linux-6.6.1/include/linux/log2.h \
    $(wildcard include/config/ARCH_HAS_ILOG2_U32) \
    $(wildcard include/config/ARCH_HAS_ILOG2_U64) \
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
  /home/jacob/contest/linux-6.6.1/include/linux/spinlock_types_raw.h \
    $(wildcard include/config/DEBUG_SPINLOCK) \
    $(wildcard include/config/DEBUG_LOCK_ALLOC) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/spinlock_types.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/qspinlock_types.h \
    $(wildcard include/config/NR_CPUS) \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/qrwlock_types.h \
  /home/jacob/contest/linux-6.6.1/include/linux/lockdep_types.h \
    $(wildcard include/config/PROVE_RAW_LOCK_NESTING) \
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
  /home/jacob/contest/linux-6.6.1/include/linux/percpu-defs.h \
    $(wildcard include/config/DEBUG_FORCE_WEAK_PER_CPU) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/current.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/asm-offsets.h \
  include/generated/asm-offsets.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/GEN-for-each-reg.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/proto.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/ldt.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/sigcontext.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cpuid.h \
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
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cpumask.h \
  /home/jacob/contest/linux-6.6.1/include/linux/cpumask.h \
    $(wildcard include/config/FORCE_NR_CPUS) \
    $(wildcard include/config/DEBUG_PER_CPU_MAPS) \
    $(wildcard include/config/CPUMASK_OFFSTACK) \
  /home/jacob/contest/linux-6.6.1/include/linux/bitmap.h \
  /home/jacob/contest/linux-6.6.1/include/linux/find.h \
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
    $(wildcard include/config/GENERIC_BUG_RELATIVE_POINTERS) \
  /home/jacob/contest/linux-6.6.1/include/linux/gfp_types.h \
    $(wildcard include/config/KASAN_HW_TAGS) \
  /home/jacob/contest/linux-6.6.1/include/linux/numa.h \
    $(wildcard include/config/NODES_SHIFT) \
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
  /home/jacob/contest/linux-6.6.1/include/linux/err.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/tsc.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cpufeature.h \
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
  /home/jacob/contest/linux-6.6.1/include/linux/spinlock.h \
    $(wildcard include/config/PREEMPTION) \
  /home/jacob/contest/linux-6.6.1/include/linux/preempt.h \
    $(wildcard include/config/PREEMPT_COUNT) \
    $(wildcard include/config/TRACE_PREEMPT_TOGGLE) \
    $(wildcard include/config/PREEMPT_NOTIFIERS) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/preempt.h \
  /home/jacob/contest/linux-6.6.1/include/linux/thread_info.h \
    $(wildcard include/config/THREAD_INFO_IN_TASK) \
    $(wildcard include/config/GENERIC_ENTRY) \
    $(wildcard include/config/HAVE_ARCH_WITHIN_STACK_FRAMES) \
    $(wildcard include/config/HARDENED_USERCOPY) \
    $(wildcard include/config/SH) \
  /home/jacob/contest/linux-6.6.1/include/linux/restart_block.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/thread_info.h \
    $(wildcard include/config/COMPAT) \
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
    $(wildcard include/config/PREEMPT) \
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
  /home/jacob/contest/linux-6.6.1/include/linux/delay.h \
  /home/jacob/contest/linux-6.6.1/include/linux/sched.h \
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
    $(wildcard include/config/CGROUP_SCHED) \
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
    $(wildcard include/config/UBSAN) \
    $(wildcard include/config/UBSAN_TRAP) \
    $(wildcard include/config/COMPACTION) \
    $(wildcard include/config/TASK_XACCT) \
    $(wildcard include/config/CPUSETS) \
    $(wildcard include/config/X86_CPU_RESCTRL) \
    $(wildcard include/config/FUTEX) \
    $(wildcard include/config/PERF_EVENTS) \
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
    $(wildcard include/config/PREEMPT_NONE) \
    $(wildcard include/config/PREEMPT_VOLUNTARY) \
    $(wildcard include/config/DEBUG_RSEQ) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/sched.h \
  /home/jacob/contest/linux-6.6.1/include/linux/pid.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rculist.h \
    $(wildcard include/config/PROVE_RCU_LIST) \
  /home/jacob/contest/linux-6.6.1/include/linux/rcupdate.h \
    $(wildcard include/config/TINY_RCU) \
    $(wildcard include/config/RCU_STRICT_GRACE_PERIOD) \
    $(wildcard include/config/RCU_LAZY) \
    $(wildcard include/config/TASKS_RCU_GENERIC) \
    $(wildcard include/config/RCU_STALL_COMMON) \
    $(wildcard include/config/KVM_XFER_TO_GUEST_WORK) \
    $(wildcard include/config/RCU_NOCB_CPU) \
    $(wildcard include/config/TASKS_RUDE_RCU) \
    $(wildcard include/config/TREE_RCU) \
    $(wildcard include/config/DEBUG_OBJECTS_RCU_HEAD) \
    $(wildcard include/config/PROVE_RCU) \
    $(wildcard include/config/ARCH_WEAK_RELEASE_ACQUIRE) \
  /home/jacob/contest/linux-6.6.1/include/linux/context_tracking_irq.h \
    $(wildcard include/config/CONTEXT_TRACKING_IDLE) \
  /home/jacob/contest/linux-6.6.1/include/linux/rcutree.h \
  /home/jacob/contest/linux-6.6.1/include/linux/wait.h \
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
    $(wildcard include/config/WQ_WATCHDOG) \
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
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/delay.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/delay.h \
  /home/jacob/contest/linux-6.6.1/include/linux/prefetch.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/local.h \
  /home/jacob/contest/linux-6.6.1/include/linux/dynamic_queue_limits.h \
  /home/jacob/contest/linux-6.6.1/include/net/net_namespace.h \
    $(wildcard include/config/NF_CONNTRACK) \
    $(wildcard include/config/NF_FLOW_TABLE) \
    $(wildcard include/config/UNIX) \
    $(wildcard include/config/IEEE802154_6LOWPAN) \
    $(wildcard include/config/IP_SCTP) \
    $(wildcard include/config/NETFILTER) \
    $(wildcard include/config/NF_TABLES) \
    $(wildcard include/config/WEXT_CORE) \
    $(wildcard include/config/IP_VS) \
    $(wildcard include/config/MPLS) \
    $(wildcard include/config/CAN) \
    $(wildcard include/config/CRYPTO_USER) \
    $(wildcard include/config/SMC) \
    $(wildcard include/config/NET_NS) \
    $(wildcard include/config/NET_NS_REFCNT_TRACKER) \
    $(wildcard include/config/NET) \
  /home/jacob/contest/linux-6.6.1/include/linux/sysctl.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/sysctl.h \
  /home/jacob/contest/linux-6.6.1/include/net/flow.h \
  /home/jacob/contest/linux-6.6.1/include/linux/in6.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/in6.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/libc-compat.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/core.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/mib.h \
    $(wildcard include/config/XFRM_STATISTICS) \
    $(wildcard include/config/TLS) \
    $(wildcard include/config/MPTCP) \
  /home/jacob/contest/linux-6.6.1/include/net/snmp.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/snmp.h \
  /home/jacob/contest/linux-6.6.1/include/linux/u64_stats_sync.h \
  arch/x86/include/generated/asm/local64.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/local64.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/unix.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/packet.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/ipv4.h \
    $(wildcard include/config/IP_MULTIPLE_TABLES) \
    $(wildcard include/config/IP_ROUTE_CLASSID) \
    $(wildcard include/config/IP_MROUTE) \
    $(wildcard include/config/IP_MROUTE_MULTIPLE_TABLES) \
    $(wildcard include/config/IP_ROUTE_MULTIPATH) \
  /home/jacob/contest/linux-6.6.1/include/net/inet_frag.h \
  /home/jacob/contest/linux-6.6.1/include/linux/completion.h \
  /home/jacob/contest/linux-6.6.1/include/linux/swait.h \
  /home/jacob/contest/linux-6.6.1/include/net/dropreason-core.h \
  /home/jacob/contest/linux-6.6.1/include/linux/siphash.h \
    $(wildcard include/config/HAVE_EFFICIENT_UNALIGNED_ACCESS) \
  /home/jacob/contest/linux-6.6.1/include/net/netns/ipv6.h \
    $(wildcard include/config/IPV6_MULTIPLE_TABLES) \
    $(wildcard include/config/IPV6_SUBTREES) \
    $(wildcard include/config/IPV6_MROUTE) \
    $(wildcard include/config/IPV6_MROUTE_MULTIPLE_TABLES) \
    $(wildcard include/config/NF_DEFRAG_IPV6) \
  /home/jacob/contest/linux-6.6.1/include/net/dst_ops.h \
  /home/jacob/contest/linux-6.6.1/include/linux/percpu_counter.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/icmpv6.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/nexthop.h \
  /home/jacob/contest/linux-6.6.1/include/linux/notifier.h \
    $(wildcard include/config/TREE_SRCU) \
  /home/jacob/contest/linux-6.6.1/include/linux/rwsem.h \
    $(wildcard include/config/RWSEM_SPIN_ON_OWNER) \
    $(wildcard include/config/DEBUG_RWSEMS) \
  /home/jacob/contest/linux-6.6.1/include/linux/srcu.h \
    $(wildcard include/config/TINY_SRCU) \
    $(wildcard include/config/NEED_SRCU_NMI_SAFE) \
  /home/jacob/contest/linux-6.6.1/include/linux/rcu_segcblist.h \
  /home/jacob/contest/linux-6.6.1/include/linux/srcutree.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rcu_node_tree.h \
    $(wildcard include/config/RCU_FANOUT) \
    $(wildcard include/config/RCU_FANOUT_LEAF) \
  /home/jacob/contest/linux-6.6.1/include/net/netns/ieee802154_6lowpan.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/sctp.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/netfilter.h \
    $(wildcard include/config/NETFILTER_FAMILY_ARP) \
    $(wildcard include/config/NETFILTER_FAMILY_BRIDGE) \
    $(wildcard include/config/NF_DEFRAG_IPV4) \
  /home/jacob/contest/linux-6.6.1/include/linux/netfilter_defs.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netfilter.h \
  /home/jacob/contest/linux-6.6.1/include/linux/in.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/in.h \
  /home/jacob/contest/linux-6.6.1/include/linux/socket.h \
  arch/x86/include/generated/uapi/asm/socket.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/socket.h \
  arch/x86/include/generated/uapi/asm/sockios.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/sockios.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/sockios.h \
  /home/jacob/contest/linux-6.6.1/include/linux/uio.h \
    $(wildcard include/config/ARCH_HAS_COPY_MC) \
  /home/jacob/contest/linux-6.6.1/include/linux/mm_types.h \
    $(wildcard include/config/HAVE_ALIGNED_STRUCT_PAGE) \
    $(wildcard include/config/USERFAULTFD) \
    $(wildcard include/config/PER_VMA_LOCK) \
    $(wildcard include/config/ANON_VMA_NAME) \
    $(wildcard include/config/SWAP) \
    $(wildcard include/config/HAVE_ARCH_COMPAT_MMAP_BASES) \
    $(wildcard include/config/MEMBARRIER) \
    $(wildcard include/config/AIO) \
    $(wildcard include/config/MMU_NOTIFIER) \
    $(wildcard include/config/TRANSPARENT_HUGEPAGE) \
    $(wildcard include/config/HUGETLB_PAGE) \
    $(wildcard include/config/KSM) \
  /home/jacob/contest/linux-6.6.1/include/linux/auxvec.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/auxvec.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/auxvec.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kref.h \
  /home/jacob/contest/linux-6.6.1/include/linux/maple_tree.h \
    $(wildcard include/config/MAPLE_RCU_DISABLED) \
    $(wildcard include/config/DEBUG_MAPLE_TREE) \
  /home/jacob/contest/linux-6.6.1/include/linux/uprobes.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/uprobes.h \
  /home/jacob/contest/linux-6.6.1/include/linux/page-flags-layout.h \
  include/generated/bounds.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/mmu.h \
    $(wildcard include/config/MODIFY_LDT_SYSCALL) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/uio.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/socket.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/conntrack.h \
    $(wildcard include/config/NF_CONNTRACK_EVENTS) \
    $(wildcard include/config/NF_CONNTRACK_LABELS) \
  /home/jacob/contest/linux-6.6.1/include/linux/list_nulls.h \
  /home/jacob/contest/linux-6.6.1/include/linux/netfilter/nf_conntrack_tcp.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netfilter/nf_conntrack_tcp.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/nftables.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/xfrm.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/xfrm.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/mpls.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/can.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/xdp.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/smc.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/bpf.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/mctp.h \
  /home/jacob/contest/linux-6.6.1/include/net/net_trackers.h \
  /home/jacob/contest/linux-6.6.1/include/linux/ref_tracker.h \
    $(wildcard include/config/REF_TRACKER) \
  /home/jacob/contest/linux-6.6.1/include/linux/stackdepot.h \
    $(wildcard include/config/STACKDEPOT_ALWAYS_INIT) \
    $(wildcard include/config/STACKDEPOT) \
  /home/jacob/contest/linux-6.6.1/include/linux/gfp.h \
    $(wildcard include/config/ZONE_DMA) \
    $(wildcard include/config/ZONE_DMA32) \
    $(wildcard include/config/ZONE_DEVICE) \
    $(wildcard include/config/CONTIG_ALLOC) \
  /home/jacob/contest/linux-6.6.1/include/linux/mmzone.h \
    $(wildcard include/config/ARCH_FORCE_MAX_ORDER) \
    $(wildcard include/config/CMA) \
    $(wildcard include/config/MEMORY_ISOLATION) \
    $(wildcard include/config/ZSMALLOC) \
    $(wildcard include/config/UNACCEPTED_MEMORY) \
    $(wildcard include/config/LRU_GEN_STATS) \
    $(wildcard include/config/MEMORY_HOTPLUG) \
    $(wildcard include/config/MEMORY_FAILURE) \
    $(wildcard include/config/PAGE_EXTENSION) \
    $(wildcard include/config/DEFERRED_STRUCT_PAGE_INIT) \
    $(wildcard include/config/HAVE_MEMORYLESS_NODES) \
    $(wildcard include/config/SPARSEMEM_EXTREME) \
    $(wildcard include/config/HAVE_ARCH_PFN_VALID) \
  /home/jacob/contest/linux-6.6.1/include/linux/pageblock-flags.h \
    $(wildcard include/config/HUGETLB_PAGE_SIZE_VARIABLE) \
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
  /home/jacob/contest/linux-6.6.1/include/linux/ns_common.h \
  /home/jacob/contest/linux-6.6.1/include/linux/idr.h \
  /home/jacob/contest/linux-6.6.1/include/linux/radix-tree.h \
  /home/jacob/contest/linux-6.6.1/include/linux/xarray.h \
    $(wildcard include/config/XARRAY_MULTI) \
  /home/jacob/contest/linux-6.6.1/include/linux/sched/mm.h \
    $(wildcard include/config/MMU_LAZY_TLB_REFCOUNT) \
    $(wildcard include/config/ARCH_HAS_MEMBARRIER_CALLBACKS) \
  /home/jacob/contest/linux-6.6.1/include/linux/sync_core.h \
    $(wildcard include/config/ARCH_HAS_SYNC_CORE_BEFORE_USERMODE) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/sync_core.h \
  /home/jacob/contest/linux-6.6.1/include/linux/skbuff.h \
    $(wildcard include/config/BRIDGE_NETFILTER) \
    $(wildcard include/config/NET_TC_SKB_EXT) \
    $(wildcard include/config/MAX_SKB_FRAGS) \
    $(wildcard include/config/NET_SOCK_MSG) \
    $(wildcard include/config/SKB_EXTENSIONS) \
    $(wildcard include/config/WIRELESS) \
    $(wildcard include/config/IPV6_NDISC_NODETYPE) \
    $(wildcard include/config/NETFILTER_XT_TARGET_TRACE) \
    $(wildcard include/config/NET_SWITCHDEV) \
    $(wildcard include/config/NET_REDIRECT) \
    $(wildcard include/config/NETFILTER_SKIP_EGRESS) \
    $(wildcard include/config/NET_RX_BUSY_POLL) \
    $(wildcard include/config/NETWORK_SECMARK) \
    $(wildcard include/config/DEBUG_NET) \
    $(wildcard include/config/PAGE_POOL) \
    $(wildcard include/config/NETWORK_PHY_TIMESTAMPING) \
    $(wildcard include/config/MCTP_FLOWS) \
  /home/jacob/contest/linux-6.6.1/include/linux/bvec.h \
  /home/jacob/contest/linux-6.6.1/include/linux/highmem.h \
  /home/jacob/contest/linux-6.6.1/include/linux/fs.h \
    $(wildcard include/config/READ_ONLY_THP_FOR_FS) \
    $(wildcard include/config/FS_POSIX_ACL) \
    $(wildcard include/config/CGROUP_WRITEBACK) \
    $(wildcard include/config/IMA) \
    $(wildcard include/config/FILE_LOCKING) \
    $(wildcard include/config/FSNOTIFY) \
    $(wildcard include/config/FS_ENCRYPTION) \
    $(wildcard include/config/FS_VERITY) \
    $(wildcard include/config/EPOLL) \
    $(wildcard include/config/UNICODE) \
    $(wildcard include/config/QUOTA) \
    $(wildcard include/config/FS_DAX) \
    $(wildcard include/config/BLOCK) \
  /home/jacob/contest/linux-6.6.1/include/linux/wait_bit.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kdev_t.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/kdev_t.h \
  /home/jacob/contest/linux-6.6.1/include/linux/dcache.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rculist_bl.h \
  /home/jacob/contest/linux-6.6.1/include/linux/list_bl.h \
  /home/jacob/contest/linux-6.6.1/include/linux/bit_spinlock.h \
  /home/jacob/contest/linux-6.6.1/include/linux/lockref.h \
    $(wildcard include/config/ARCH_USE_CMPXCHG_LOCKREF) \
  /home/jacob/contest/linux-6.6.1/include/linux/stringhash.h \
    $(wildcard include/config/DCACHE_WORD_ACCESS) \
  /home/jacob/contest/linux-6.6.1/include/linux/hash.h \
    $(wildcard include/config/HAVE_ARCH_HASH) \
  /home/jacob/contest/linux-6.6.1/include/linux/path.h \
  /home/jacob/contest/linux-6.6.1/include/linux/stat.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/stat.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/stat.h \
  /home/jacob/contest/linux-6.6.1/include/linux/list_lru.h \
    $(wildcard include/config/MEMCG_KMEM) \
  /home/jacob/contest/linux-6.6.1/include/linux/shrinker.h \
    $(wildcard include/config/SHRINKER_DEBUG) \
  /home/jacob/contest/linux-6.6.1/include/linux/capability.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/capability.h \
  /home/jacob/contest/linux-6.6.1/include/linux/semaphore.h \
  /home/jacob/contest/linux-6.6.1/include/linux/fcntl.h \
    $(wildcard include/config/ARCH_32BIT_OFF_T) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/fcntl.h \
  arch/x86/include/generated/uapi/asm/fcntl.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/fcntl.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/openat2.h \
  /home/jacob/contest/linux-6.6.1/include/linux/migrate_mode.h \
  /home/jacob/contest/linux-6.6.1/include/linux/percpu-rwsem.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rcuwait.h \
  /home/jacob/contest/linux-6.6.1/include/linux/sched/signal.h \
    $(wildcard include/config/SCHED_AUTOGROUP) \
    $(wildcard include/config/BSD_PROCESS_ACCT) \
    $(wildcard include/config/TASKSTATS) \
    $(wildcard include/config/STACK_GROWSUP) \
  /home/jacob/contest/linux-6.6.1/include/linux/signal.h \
    $(wildcard include/config/DYNAMIC_SIGFRAME) \
  /home/jacob/contest/linux-6.6.1/include/linux/sched/jobctl.h \
  /home/jacob/contest/linux-6.6.1/include/linux/sched/task.h \
    $(wildcard include/config/HAVE_EXIT_THREAD) \
    $(wildcard include/config/ARCH_WANTS_DYNAMIC_TASK_STRUCT) \
    $(wildcard include/config/HAVE_ARCH_THREAD_STRUCT_WHITELIST) \
  /home/jacob/contest/linux-6.6.1/include/linux/uaccess.h \
    $(wildcard include/config/ARCH_HAS_SUBPAGE_FAULTS) \
  /home/jacob/contest/linux-6.6.1/include/linux/fault-inject-usercopy.h \
    $(wildcard include/config/FAULT_INJECTION_USERCOPY) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/uaccess.h \
    $(wildcard include/config/CC_HAS_ASM_GOTO_OUTPUT) \
    $(wildcard include/config/CC_HAS_ASM_GOTO_TIED_OUTPUT) \
    $(wildcard include/config/X86_INTEL_USERCOPY) \
  /home/jacob/contest/linux-6.6.1/include/linux/mmap_lock.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/smap.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/extable.h \
    $(wildcard include/config/BPF_JIT) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/tlbflush.h \
  /home/jacob/contest/linux-6.6.1/include/linux/mmu_notifier.h \
  /home/jacob/contest/linux-6.6.1/include/linux/interval_tree.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/invpcid.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/pti.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/pgtable.h \
    $(wildcard include/config/DEBUG_WX) \
    $(wildcard include/config/HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD) \
    $(wildcard include/config/ARCH_HAS_PTE_DEVMAP) \
    $(wildcard include/config/HAVE_ARCH_SOFT_DIRTY) \
    $(wildcard include/config/ARCH_ENABLE_THP_MIGRATION) \
    $(wildcard include/config/PAGE_TABLE_CHECK) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/pkru.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/fpu/api.h \
    $(wildcard include/config/X86_DEBUG_FPU) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/coco.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/pgtable_uffd.h \
  /home/jacob/contest/linux-6.6.1/include/linux/page_table_check.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/pgtable_64.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/fixmap.h \
    $(wildcard include/config/PROVIDE_OHCI1394_DMA_INIT) \
    $(wildcard include/config/X86_IO_APIC) \
    $(wildcard include/config/PCI_MMCONFIG) \
    $(wildcard include/config/ACPI_APEI_GHES) \
    $(wildcard include/config/INTEL_TXT) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/uapi/asm/vsyscall.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/fixmap.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/pgtable-invert.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/uaccess_64.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/access_ok.h \
    $(wildcard include/config/ALTERNATE_USER_ADDRESS_SPACE) \
  /home/jacob/contest/linux-6.6.1/include/linux/cred.h \
    $(wildcard include/config/DEBUG_CREDENTIALS) \
  /home/jacob/contest/linux-6.6.1/include/linux/key.h \
    $(wildcard include/config/KEY_NOTIFICATIONS) \
  /home/jacob/contest/linux-6.6.1/include/linux/assoc_array.h \
    $(wildcard include/config/ASSOCIATIVE_ARRAY) \
  /home/jacob/contest/linux-6.6.1/include/linux/sched/user.h \
    $(wildcard include/config/VFIO_PCI_ZDEV_KVM) \
    $(wildcard include/config/IOMMUFD) \
    $(wildcard include/config/WATCH_QUEUE) \
  /home/jacob/contest/linux-6.6.1/include/linux/ratelimit.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rcu_sync.h \
  /home/jacob/contest/linux-6.6.1/include/linux/delayed_call.h \
  /home/jacob/contest/linux-6.6.1/include/linux/uuid.h \
  /home/jacob/contest/linux-6.6.1/include/linux/errseq.h \
  /home/jacob/contest/linux-6.6.1/include/linux/ioprio.h \
  /home/jacob/contest/linux-6.6.1/include/linux/sched/rt.h \
  /home/jacob/contest/linux-6.6.1/include/linux/iocontext.h \
    $(wildcard include/config/BLK_ICQ) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/ioprio.h \
  /home/jacob/contest/linux-6.6.1/include/linux/fs_types.h \
  /home/jacob/contest/linux-6.6.1/include/linux/mount.h \
  /home/jacob/contest/linux-6.6.1/include/linux/mnt_idmapping.h \
  /home/jacob/contest/linux-6.6.1/include/linux/slab.h \
    $(wildcard include/config/DEBUG_SLAB) \
    $(wildcard include/config/SLUB_TINY) \
    $(wildcard include/config/FAILSLAB) \
    $(wildcard include/config/KFENCE) \
    $(wildcard include/config/SLAB) \
    $(wildcard include/config/SLUB) \
  /home/jacob/contest/linux-6.6.1/include/linux/overflow.h \
  /home/jacob/contest/linux-6.6.1/include/linux/percpu-refcount.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kasan.h \
    $(wildcard include/config/KASAN_STACK) \
    $(wildcard include/config/KASAN_VMALLOC) \
  /home/jacob/contest/linux-6.6.1/include/linux/kasan-enabled.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/fs.h \
  /home/jacob/contest/linux-6.6.1/include/linux/quota.h \
    $(wildcard include/config/QUOTA_NETLINK_INTERFACE) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/dqblk_xfs.h \
  /home/jacob/contest/linux-6.6.1/include/linux/dqblk_v1.h \
  /home/jacob/contest/linux-6.6.1/include/linux/dqblk_v2.h \
  /home/jacob/contest/linux-6.6.1/include/linux/dqblk_qtree.h \
  /home/jacob/contest/linux-6.6.1/include/linux/projid.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/quota.h \
  /home/jacob/contest/linux-6.6.1/include/linux/cacheflush.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/cacheflush.h \
  /home/jacob/contest/linux-6.6.1/include/linux/mm.h \
    $(wildcard include/config/HAVE_ARCH_MMAP_RND_BITS) \
    $(wildcard include/config/HAVE_ARCH_MMAP_RND_COMPAT_BITS) \
    $(wildcard include/config/ARCH_USES_HIGH_VMA_FLAGS) \
    $(wildcard include/config/ARCH_HAS_PKEYS) \
    $(wildcard include/config/PPC) \
    $(wildcard include/config/PARISC) \
    $(wildcard include/config/IA64) \
    $(wildcard include/config/SPARC64) \
    $(wildcard include/config/ARM64_MTE) \
    $(wildcard include/config/HAVE_ARCH_USERFAULTFD_MINOR) \
    $(wildcard include/config/SHMEM) \
    $(wildcard include/config/MIGRATION) \
    $(wildcard include/config/ARCH_HAS_PTE_SPECIAL) \
    $(wildcard include/config/DEBUG_VM_RB) \
    $(wildcard include/config/PAGE_POISONING) \
    $(wildcard include/config/INIT_ON_ALLOC_DEFAULT_ON) \
    $(wildcard include/config/INIT_ON_FREE_DEFAULT_ON) \
    $(wildcard include/config/DEBUG_PAGEALLOC) \
    $(wildcard include/config/ARCH_WANT_OPTIMIZE_DAX_VMEMMAP) \
    $(wildcard include/config/HUGETLBFS) \
    $(wildcard include/config/MAPPING_DIRTY_HELPERS) \
  /home/jacob/contest/linux-6.6.1/include/linux/page_ext.h \
  /home/jacob/contest/linux-6.6.1/include/linux/stacktrace.h \
    $(wildcard include/config/ARCH_STACKWALK) \
    $(wildcard include/config/STACKTRACE) \
    $(wildcard include/config/HAVE_RELIABLE_STACKTRACE) \
  /home/jacob/contest/linux-6.6.1/include/linux/page_ref.h \
    $(wildcard include/config/DEBUG_PAGE_REF) \
  /home/jacob/contest/linux-6.6.1/include/linux/sizes.h \
  /home/jacob/contest/linux-6.6.1/include/linux/pgtable.h \
    $(wildcard include/config/HIGHPTE) \
    $(wildcard include/config/ARCH_HAS_NONLEAF_PMD_YOUNG) \
    $(wildcard include/config/GUP_GET_PXX_LOW_HIGH) \
    $(wildcard include/config/ARCH_WANT_PMD_MKWRITE) \
    $(wildcard include/config/HAVE_ARCH_HUGE_VMAP) \
    $(wildcard include/config/X86_ESPFIX64) \
  /home/jacob/contest/linux-6.6.1/include/linux/memremap.h \
    $(wildcard include/config/DEVICE_PRIVATE) \
    $(wildcard include/config/PCI_P2PDMA) \
  /home/jacob/contest/linux-6.6.1/include/linux/ioport.h \
  /home/jacob/contest/linux-6.6.1/include/linux/huge_mm.h \
  /home/jacob/contest/linux-6.6.1/include/linux/sched/coredump.h \
    $(wildcard include/config/CORE_DUMP_DEFAULT_ELF_HEADERS) \
  /home/jacob/contest/linux-6.6.1/include/linux/vmstat.h \
    $(wildcard include/config/VM_EVENT_COUNTERS) \
    $(wildcard include/config/DEBUG_TLBFLUSH) \
    $(wildcard include/config/PER_VMA_LOCK_STATS) \
  /home/jacob/contest/linux-6.6.1/include/linux/vm_event_item.h \
    $(wildcard include/config/MEMORY_BALLOON) \
    $(wildcard include/config/BALLOON_COMPACTION) \
    $(wildcard include/config/ZSWAP) \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/cacheflush.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kmsan.h \
  /home/jacob/contest/linux-6.6.1/include/linux/dma-direction.h \
  /home/jacob/contest/linux-6.6.1/include/linux/hardirq.h \
  /home/jacob/contest/linux-6.6.1/include/linux/context_tracking_state.h \
    $(wildcard include/config/CONTEXT_TRACKING_USER) \
    $(wildcard include/config/CONTEXT_TRACKING) \
  /home/jacob/contest/linux-6.6.1/include/linux/ftrace_irq.h \
    $(wildcard include/config/HWLAT_TRACER) \
    $(wildcard include/config/OSNOISE_TRACER) \
  /home/jacob/contest/linux-6.6.1/include/linux/vtime.h \
    $(wildcard include/config/VIRT_CPU_ACCOUNTING) \
    $(wildcard include/config/IRQ_TIME_ACCOUNTING) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/hardirq.h \
    $(wildcard include/config/KVM_INTEL) \
    $(wildcard include/config/HAVE_KVM) \
    $(wildcard include/config/X86_THERMAL_VECTOR) \
    $(wildcard include/config/X86_MCE_THRESHOLD) \
    $(wildcard include/config/X86_MCE_AMD) \
    $(wildcard include/config/X86_HV_CALLBACK_VECTOR) \
    $(wildcard include/config/HYPERV) \
  /home/jacob/contest/linux-6.6.1/include/linux/highmem-internal.h \
  /home/jacob/contest/linux-6.6.1/include/net/checksum.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/checksum.h \
    $(wildcard include/config/GENERIC_CSUM) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/checksum_64.h \
  /home/jacob/contest/linux-6.6.1/include/linux/dma-mapping.h \
    $(wildcard include/config/DMA_API_DEBUG) \
    $(wildcard include/config/HAS_DMA) \
    $(wildcard include/config/NEED_DMA_MAP_STATE) \
  /home/jacob/contest/linux-6.6.1/include/linux/device.h \
    $(wildcard include/config/HAS_IOMEM) \
    $(wildcard include/config/GENERIC_MSI_IRQ) \
    $(wildcard include/config/ENERGY_MODEL) \
    $(wildcard include/config/PINCTRL) \
    $(wildcard include/config/DMA_OPS) \
    $(wildcard include/config/DMA_DECLARE_COHERENT) \
    $(wildcard include/config/DMA_CMA) \
    $(wildcard include/config/SWIOTLB) \
    $(wildcard include/config/SWIOTLB_DYNAMIC) \
    $(wildcard include/config/ARCH_HAS_SYNC_DMA_FOR_DEVICE) \
    $(wildcard include/config/ARCH_HAS_SYNC_DMA_FOR_CPU) \
    $(wildcard include/config/ARCH_HAS_SYNC_DMA_FOR_CPU_ALL) \
    $(wildcard include/config/DMA_OPS_BYPASS) \
    $(wildcard include/config/PM_SLEEP) \
    $(wildcard include/config/OF) \
    $(wildcard include/config/DEVTMPFS) \
  /home/jacob/contest/linux-6.6.1/include/linux/dev_printk.h \
  /home/jacob/contest/linux-6.6.1/include/linux/energy_model.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kobject.h \
    $(wildcard include/config/UEVENT_HELPER) \
    $(wildcard include/config/DEBUG_KOBJECT_RELEASE) \
  /home/jacob/contest/linux-6.6.1/include/linux/sysfs.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kernfs.h \
    $(wildcard include/config/KERNFS) \
  /home/jacob/contest/linux-6.6.1/include/linux/kobject_ns.h \
  /home/jacob/contest/linux-6.6.1/include/linux/sched/cpufreq.h \
    $(wildcard include/config/CPU_FREQ) \
  /home/jacob/contest/linux-6.6.1/include/linux/sched/topology.h \
    $(wildcard include/config/SCHED_DEBUG) \
    $(wildcard include/config/SCHED_CLUSTER) \
    $(wildcard include/config/SCHED_MC) \
    $(wildcard include/config/CPU_FREQ_GOV_SCHEDUTIL) \
  /home/jacob/contest/linux-6.6.1/include/linux/sched/idle.h \
  /home/jacob/contest/linux-6.6.1/include/linux/sched/sd_flags.h \
  /home/jacob/contest/linux-6.6.1/include/linux/klist.h \
  /home/jacob/contest/linux-6.6.1/include/linux/pm.h \
    $(wildcard include/config/VT_CONSOLE_SLEEP) \
    $(wildcard include/config/CXL_SUSPEND) \
    $(wildcard include/config/PM) \
    $(wildcard include/config/PM_CLK) \
    $(wildcard include/config/PM_GENERIC_DOMAINS) \
  /home/jacob/contest/linux-6.6.1/include/linux/device/bus.h \
    $(wildcard include/config/ACPI) \
  /home/jacob/contest/linux-6.6.1/include/linux/device/class.h \
  /home/jacob/contest/linux-6.6.1/include/linux/device/driver.h \
  /home/jacob/contest/linux-6.6.1/include/linux/module.h \
    $(wildcard include/config/MODULES_TREE_LOOKUP) \
    $(wildcard include/config/STACKTRACE_BUILD_ID) \
    $(wildcard include/config/ARCH_USES_CFI_TRAPS) \
    $(wildcard include/config/MODULE_SIG) \
    $(wildcard include/config/KALLSYMS) \
    $(wildcard include/config/BPF_EVENTS) \
    $(wildcard include/config/DEBUG_INFO_BTF_MODULES) \
    $(wildcard include/config/EVENT_TRACING) \
    $(wildcard include/config/MODULE_UNLOAD) \
    $(wildcard include/config/CONSTRUCTORS) \
    $(wildcard include/config/FUNCTION_ERROR_INJECTION) \
  /home/jacob/contest/linux-6.6.1/include/linux/buildid.h \
    $(wildcard include/config/CRASH_CORE) \
  /home/jacob/contest/linux-6.6.1/include/linux/kmod.h \
  /home/jacob/contest/linux-6.6.1/include/linux/umh.h \
  /home/jacob/contest/linux-6.6.1/include/linux/elf.h \
    $(wildcard include/config/ARCH_USE_GNU_PROPERTY) \
    $(wildcard include/config/ARCH_HAVE_ELF_PROT) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/elf.h \
    $(wildcard include/config/X86_X32_ABI) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/user.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/user_64.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/fsgsbase.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/vdso.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/elf.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/elf-em.h \
  /home/jacob/contest/linux-6.6.1/include/linux/moduleparam.h \
    $(wildcard include/config/ALPHA) \
    $(wildcard include/config/PPC64) \
  /home/jacob/contest/linux-6.6.1/include/linux/rbtree_latch.h \
  /home/jacob/contest/linux-6.6.1/include/linux/error-injection.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/error-injection.h \
  /home/jacob/contest/linux-6.6.1/include/linux/dynamic_debug.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/module.h \
    $(wildcard include/config/UNWINDER_ORC) \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/module.h \
    $(wildcard include/config/HAVE_MOD_ARCH_SPECIFIC) \
    $(wildcard include/config/MODULES_USE_ELF_REL) \
    $(wildcard include/config/MODULES_USE_ELF_RELA) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/device.h \
  /home/jacob/contest/linux-6.6.1/include/linux/pm_wakeup.h \
  /home/jacob/contest/linux-6.6.1/include/linux/scatterlist.h \
    $(wildcard include/config/NEED_SG_DMA_LENGTH) \
    $(wildcard include/config/NEED_SG_DMA_FLAGS) \
    $(wildcard include/config/DEBUG_SG) \
    $(wildcard include/config/SGL_ALLOC) \
    $(wildcard include/config/ARCH_NO_SG_CHAIN) \
    $(wildcard include/config/SG_POOL) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/io.h \
    $(wildcard include/config/MTRR) \
    $(wildcard include/config/X86_PAT) \
  arch/x86/include/generated/asm/early_ioremap.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/early_ioremap.h \
    $(wildcard include/config/GENERIC_EARLY_IOREMAP) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/shared/io.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/io.h \
    $(wildcard include/config/GENERIC_IOMAP) \
    $(wildcard include/config/TRACE_MMIO_ACCESS) \
    $(wildcard include/config/GENERIC_IOREMAP) \
    $(wildcard include/config/HAS_IOPORT_MAP) \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/iomap.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/pci_iomap.h \
    $(wildcard include/config/PCI) \
    $(wildcard include/config/NO_GENERIC_PCI_IOPORT_MAP) \
    $(wildcard include/config/GENERIC_PCI_IOMAP) \
  /home/jacob/contest/linux-6.6.1/include/linux/logic_pio.h \
    $(wildcard include/config/INDIRECT_PIO) \
  /home/jacob/contest/linux-6.6.1/include/linux/fwnode.h \
  /home/jacob/contest/linux-6.6.1/include/linux/vmalloc.h \
    $(wildcard include/config/HAVE_ARCH_HUGE_VMALLOC) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/vmalloc.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/pgtable_areas.h \
  /home/jacob/contest/linux-6.6.1/include/linux/netdev_features.h \
  /home/jacob/contest/linux-6.6.1/include/net/flow_dissector.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/if_ether.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/if_packet.h \
  /home/jacob/contest/linux-6.6.1/include/linux/netfilter/nf_conntrack_common.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netfilter/nf_conntrack_common.h \
  /home/jacob/contest/linux-6.6.1/include/net/net_debug.h \
  /home/jacob/contest/linux-6.6.1/include/linux/seq_file_net.h \
  /home/jacob/contest/linux-6.6.1/include/linux/seq_file.h \
  /home/jacob/contest/linux-6.6.1/include/linux/string_helpers.h \
  /home/jacob/contest/linux-6.6.1/include/linux/ctype.h \
  /home/jacob/contest/linux-6.6.1/include/linux/string_choices.h \
  /home/jacob/contest/linux-6.6.1/include/net/netprio_cgroup.h \
  /home/jacob/contest/linux-6.6.1/include/linux/cgroup.h \
    $(wildcard include/config/DEBUG_CGROUP_REF) \
    $(wildcard include/config/CGROUP_CPUACCT) \
    $(wildcard include/config/SOCK_CGROUP_DATA) \
    $(wildcard include/config/CGROUP_DATA) \
    $(wildcard include/config/CGROUP_BPF) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/cgroupstats.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/taskstats.h \
  /home/jacob/contest/linux-6.6.1/include/linux/nsproxy.h \
  /home/jacob/contest/linux-6.6.1/include/linux/user_namespace.h \
    $(wildcard include/config/INOTIFY_USER) \
    $(wildcard include/config/FANOTIFY) \
    $(wildcard include/config/PERSISTENT_KEYRINGS) \
  /home/jacob/contest/linux-6.6.1/include/linux/kernel_stat.h \
  /home/jacob/contest/linux-6.6.1/include/linux/interrupt.h \
    $(wildcard include/config/IRQ_FORCED_THREADING) \
    $(wildcard include/config/GENERIC_IRQ_PROBE) \
    $(wildcard include/config/IRQ_TIMINGS) \
  /home/jacob/contest/linux-6.6.1/include/linux/irqreturn.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/irq.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/irq_vectors.h \
    $(wildcard include/config/PCI_MSI) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/sections.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/sections.h \
    $(wildcard include/config/HAVE_FUNCTION_DESCRIPTORS) \
  /home/jacob/contest/linux-6.6.1/include/linux/cgroup-defs.h \
    $(wildcard include/config/CGROUP_NET_CLASSID) \
  /home/jacob/contest/linux-6.6.1/include/linux/bpf-cgroup-defs.h \
    $(wildcard include/config/BPF_LSM) \
  /home/jacob/contest/linux-6.6.1/include/linux/psi_types.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kthread.h \
  /home/jacob/contest/linux-6.6.1/include/linux/cgroup_subsys.h \
    $(wildcard include/config/CGROUP_DEVICE) \
    $(wildcard include/config/CGROUP_FREEZER) \
    $(wildcard include/config/CGROUP_PERF) \
    $(wildcard include/config/CGROUP_HUGETLB) \
    $(wildcard include/config/CGROUP_PIDS) \
    $(wildcard include/config/CGROUP_RDMA) \
    $(wildcard include/config/CGROUP_MISC) \
    $(wildcard include/config/CGROUP_DEBUG) \
  /home/jacob/contest/linux-6.6.1/include/linux/cgroup_refcnt.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/neighbour.h \
  /home/jacob/contest/linux-6.6.1/include/linux/netlink.h \
  /home/jacob/contest/linux-6.6.1/include/net/scm.h \
    $(wildcard include/config/SECURITY_NETWORK) \
  /home/jacob/contest/linux-6.6.1/include/linux/net.h \
  /home/jacob/contest/linux-6.6.1/include/linux/sockptr.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/net.h \
  /home/jacob/contest/linux-6.6.1/include/linux/security.h \
    $(wildcard include/config/SECURITY_INFINIBAND) \
    $(wildcard include/config/SECURITY_NETWORK_XFRM) \
    $(wildcard include/config/SECURITY_PATH) \
    $(wildcard include/config/SECURITYFS) \
  /home/jacob/contest/linux-6.6.1/include/linux/kernel_read_file.h \
  /home/jacob/contest/linux-6.6.1/include/linux/file.h \
  /home/jacob/contest/linux-6.6.1/include/net/compat.h \
  /home/jacob/contest/linux-6.6.1/include/linux/compat.h \
    $(wildcard include/config/ARCH_HAS_SYSCALL_WRAPPER) \
    $(wildcard include/config/COMPAT_OLD_SIGACTION) \
    $(wildcard include/config/ODD_RT_SIGACTION) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/if.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/hdlc/ioctl.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/aio_abi.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/compat.h \
  /home/jacob/contest/linux-6.6.1/include/linux/sched/task_stack.h \
    $(wildcard include/config/DEBUG_STACK_USAGE) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/magic.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/user32.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/compat.h \
    $(wildcard include/config/COMPAT_FOR_U64_ALIGNMENT) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/syscall_wrapper.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netlink.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netdevice.h \
  /home/jacob/contest/linux-6.6.1/include/linux/if_ether.h \
  /home/jacob/contest/linux-6.6.1/include/linux/if_link.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/if_link.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/if_bonding.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/pkt_cls.h \
    $(wildcard include/config/NET_CLS_ACT) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/pkt_sched.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netdev.h \
  /home/jacob/contest/linux-6.6.1/include/linux/hashtable.h \
  /home/jacob/contest/linux-6.6.1/include/net/sock.h \
    $(wildcard include/config/SOCK_RX_QUEUE_MAPPING) \
    $(wildcard include/config/SOCK_VALIDATE_XMIT) \
  /home/jacob/contest/linux-6.6.1/include/linux/page_counter.h \
  /home/jacob/contest/linux-6.6.1/include/linux/memcontrol.h \
  /home/jacob/contest/linux-6.6.1/include/linux/vmpressure.h \
  /home/jacob/contest/linux-6.6.1/include/linux/eventfd.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/eventfd.h \
  /home/jacob/contest/linux-6.6.1/include/linux/writeback.h \
  /home/jacob/contest/linux-6.6.1/include/linux/flex_proportions.h \
  /home/jacob/contest/linux-6.6.1/include/linux/backing-dev-defs.h \
    $(wildcard include/config/DEBUG_FS) \
  /home/jacob/contest/linux-6.6.1/include/linux/blk_types.h \
    $(wildcard include/config/FAIL_MAKE_REQUEST) \
    $(wildcard include/config/BLK_CGROUP_IOCOST) \
    $(wildcard include/config/BLK_INLINE_ENCRYPTION) \
    $(wildcard include/config/BLK_DEV_INTEGRITY) \
  /home/jacob/contest/linux-6.6.1/include/linux/rculist_nulls.h \
  /home/jacob/contest/linux-6.6.1/include/linux/poll.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/poll.h \
  arch/x86/include/generated/uapi/asm/poll.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/asm-generic/poll.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/eventpoll.h \
  /home/jacob/contest/linux-6.6.1/include/linux/indirect_call_wrapper.h \
  /home/jacob/contest/linux-6.6.1/include/net/dst.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rtnetlink.h \
    $(wildcard include/config/NET_INGRESS) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/rtnetlink.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/if_addr.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rcuref.h \
  /home/jacob/contest/linux-6.6.1/include/net/neighbour.h \
  /home/jacob/contest/linux-6.6.1/include/net/rtnetlink.h \
  /home/jacob/contest/linux-6.6.1/include/net/netlink.h \
  /home/jacob/contest/linux-6.6.1/include/net/tcp_states.h \
  /home/jacob/contest/linux-6.6.1/include/linux/net_tstamp.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/net_tstamp.h \
  /home/jacob/contest/linux-6.6.1/include/net/l3mdev.h \
  /home/jacob/contest/linux-6.6.1/include/net/fib_rules.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/fib_rules.h \
  /home/jacob/contest/linux-6.6.1/include/net/fib_notifier.h \
  /home/jacob/contest/linux-6.6.1/include/net/request_sock.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/hash.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/udp.h \
  /home/jacob/contest/linux-6.6.1/include/linux/tcp.h \
    $(wildcard include/config/BPF) \
    $(wildcard include/config/TCP_MD5SIG) \
  /home/jacob/contest/linux-6.6.1/include/linux/win_minmax.h \
  /home/jacob/contest/linux-6.6.1/include/net/inet_connection_sock.h \
  /home/jacob/contest/linux-6.6.1/include/net/inet_timewait_sock.h \
  /home/jacob/contest/linux-6.6.1/include/net/timewait_sock.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/tcp.h \
  /home/jacob/contest/linux-6.6.1/include/linux/icmp.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/icmp.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/errqueue.h \
  /home/jacob/contest/linux-6.6.1/include/linux/icmpv6.h \
    $(wildcard include/config/NF_NAT) \
  /home/jacob/contest/linux-6.6.1/include/linux/ipv6.h \
    $(wildcard include/config/IPV6_ROUTER_PREF) \
    $(wildcard include/config/IPV6_ROUTE_INFO) \
    $(wildcard include/config/IPV6_OPTIMISTIC_DAD) \
    $(wildcard include/config/IPV6_SEG6_HMAC) \
    $(wildcard include/config/IPV6_MIP6) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/ipv6.h \
  /home/jacob/contest/linux-6.6.1/include/linux/dccp.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/dccp.h \
  /home/jacob/contest/linux-6.6.1/include/linux/sctp.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/sctp.h \
  /home/jacob/contest/linux-6.6.1/include/net/sctp/checksum.h \
  /home/jacob/contest/linux-6.6.1/include/linux/crc32c.h \
  /home/jacob/contest/linux-6.6.1/include/linux/crc32.h \
  /home/jacob/contest/linux-6.6.1/include/linux/bitrev.h \
    $(wildcard include/config/HAVE_ARCH_BITREVERSE) \
  /home/jacob/contest/linux-6.6.1/include/linux/netfilter.h \
  /home/jacob/contest/linux-6.6.1/include/linux/netfilter/nf_conntrack_zones_common.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netfilter/nf_conntrack_tuple_common.h \
  /home/jacob/contest/linux-6.6.1/include/net/netfilter/nf_nat.h \
    $(wildcard include/config/NF_NAT_PPTP) \
    $(wildcard include/config/NF_NAT_MASQUERADE) \
  /home/jacob/contest/linux-6.6.1/include/linux/netfilter_ipv4.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netfilter_ipv4.h \
  /home/jacob/contest/linux-6.6.1/include/linux/netfilter/nf_conntrack_pptp.h \
  /home/jacob/contest/linux-6.6.1/include/net/netfilter/nf_conntrack_expect.h \
  /home/jacob/contest/linux-6.6.1/include/net/netfilter/nf_conntrack.h \
    $(wildcard include/config/NF_CONNTRACK_ZONES) \
    $(wildcard include/config/NF_CONNTRACK_MARK) \
    $(wildcard include/config/NF_CONNTRACK_SECMARK) \
  /home/jacob/contest/linux-6.6.1/include/linux/netfilter/nf_conntrack_dccp.h \
  /home/jacob/contest/linux-6.6.1/include/linux/netfilter/nf_conntrack_sctp.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netfilter/nf_conntrack_sctp.h \
  /home/jacob/contest/linux-6.6.1/include/linux/netfilter/nf_conntrack_proto_gre.h \
  /home/jacob/contest/linux-6.6.1/include/net/gre.h \
  /home/jacob/contest/linux-6.6.1/include/net/ip_tunnels.h \
    $(wildcard include/config/DST_CACHE) \
    $(wildcard include/config/IPV6_SIT_6RD) \
  /home/jacob/contest/linux-6.6.1/include/linux/if_tunnel.h \
  /home/jacob/contest/linux-6.6.1/include/linux/ip.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/ip.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/if_tunnel.h \
  /home/jacob/contest/linux-6.6.1/include/net/dsfield.h \
  /home/jacob/contest/linux-6.6.1/include/net/gro_cells.h \
  /home/jacob/contest/linux-6.6.1/include/net/inet_ecn.h \
  /home/jacob/contest/linux-6.6.1/include/linux/if_vlan.h \
  /home/jacob/contest/linux-6.6.1/include/linux/etherdevice.h \
  arch/x86/include/generated/asm/unaligned.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/unaligned.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/if_vlan.h \
  /home/jacob/contest/linux-6.6.1/include/net/netns/generic.h \
  /home/jacob/contest/linux-6.6.1/include/net/lwtunnel.h \
    $(wildcard include/config/LWTUNNEL) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/lwtunnel.h \
  /home/jacob/contest/linux-6.6.1/include/net/route.h \
  /home/jacob/contest/linux-6.6.1/include/net/inetpeer.h \
  /home/jacob/contest/linux-6.6.1/include/net/ipv6.h \
  /home/jacob/contest/linux-6.6.1/include/linux/jump_label_ratelimit.h \
  /home/jacob/contest/linux-6.6.1/include/net/if_inet6.h \
  /home/jacob/contest/linux-6.6.1/include/net/inet_dscp.h \
  /home/jacob/contest/linux-6.6.1/include/net/ip_fib.h \
  /home/jacob/contest/linux-6.6.1/include/net/arp.h \
  /home/jacob/contest/linux-6.6.1/include/linux/if_arp.h \
    $(wildcard include/config/FIREWIRE_NET) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/if_arp.h \
  /home/jacob/contest/linux-6.6.1/include/net/ndisc.h \
  /home/jacob/contest/linux-6.6.1/include/net/ipv6_stubs.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/in_route.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/route.h \
  /home/jacob/contest/linux-6.6.1/include/net/dst_cache.h \
  /home/jacob/contest/linux-6.6.1/include/net/ip6_fib.h \
  /home/jacob/contest/linux-6.6.1/include/linux/ipv6_route.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/ipv6_route.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/bpf.h \
    $(wildcard include/config/BPF_LIRC_MODE2) \
    $(wildcard include/config/EFFICIENT_UNALIGNED_ACCESS) \
    $(wildcard include/config/BPF_KPROBE_OVERRIDE) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/bpf_common.h \
  /home/jacob/contest/linux-6.6.1/include/net/ip6_route.h \
  /home/jacob/contest/linux-6.6.1/include/net/addrconf.h \
  /home/jacob/contest/linux-6.6.1/include/net/nexthop.h \
  /home/jacob/contest/linux-6.6.1/include/net/pptp.h \
  /home/jacob/contest/linux-6.6.1/include/net/netfilter/nf_conntrack_tuple.h \
  /home/jacob/contest/linux-6.6.1/include/linux/netfilter/x_tables.h \
    $(wildcard include/config/NETFILTER_XTABLES_COMPAT) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netfilter/x_tables.h \
  /home/jacob/contest/linux-6.6.1/include/net/netfilter/ipv4/nf_conntrack_ipv4.h \
  /home/jacob/contest/linux-6.6.1/include/net/netfilter/ipv6/nf_conntrack_ipv6.h \
  /home/jacob/contest/linux-6.6.1/include/net/netfilter/nf_conntrack_zones.h \
  /home/jacob/contest/linux-6.6.1/include/net/netfilter/nf_conntrack_extend.h \
    $(wildcard include/config/NF_CONNTRACK_TIMESTAMP) \
    $(wildcard include/config/NF_CONNTRACK_TIMEOUT) \
    $(wildcard include/config/NETFILTER_SYNPROXY) \
    $(wildcard include/config/NET_ACT_CT) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netfilter/nf_nat.h \
  /home/jacob/contest/linux-6.6.1/include/linux/netfilter_ipv6.h \
    $(wildcard include/config/SYN_COOKIES) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netfilter_ipv6.h \
  /home/jacob/contest/linux-6.6.1/include/net/tcp.h \
  /home/jacob/contest/linux-6.6.1/include/net/inet_hashtables.h \
    $(wildcard include/config/IP_DCCP) \
  /home/jacob/contest/linux-6.6.1/include/net/ip.h \
  /home/jacob/contest/linux-6.6.1/include/net/sock_reuseport.h \
  /home/jacob/contest/linux-6.6.1/include/linux/filter.h \
    $(wildcard include/config/BPF_JIT_ALWAYS_ON) \
    $(wildcard include/config/HAVE_EBPF_JIT) \
  /home/jacob/contest/linux-6.6.1/include/linux/bpf.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/filter.h \
  /home/jacob/contest/linux-6.6.1/include/linux/kallsyms.h \
    $(wildcard include/config/KALLSYMS_ALL) \
  /home/jacob/contest/linux-6.6.1/include/linux/bpfptr.h \
  /home/jacob/contest/linux-6.6.1/include/linux/btf.h \
  /home/jacob/contest/linux-6.6.1/include/linux/bsearch.h \
  /home/jacob/contest/linux-6.6.1/include/linux/btf_ids.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/btf.h \
  /home/jacob/contest/linux-6.6.1/include/linux/rcupdate_trace.h \
    $(wildcard include/config/TASKS_TRACE_RCU_READ_MB) \
  /home/jacob/contest/linux-6.6.1/include/linux/static_call.h \
  /home/jacob/contest/linux-6.6.1/include/linux/cpu.h \
    $(wildcard include/config/PM_SLEEP_SMP) \
    $(wildcard include/config/PM_SLEEP_SMP_NONZERO_CPU) \
    $(wildcard include/config/ARCH_HAS_CPU_FINALIZE_INIT) \
  /home/jacob/contest/linux-6.6.1/include/linux/node.h \
    $(wildcard include/config/HMEM_REPORTING) \
  /home/jacob/contest/linux-6.6.1/include/linux/cpuhotplug.h \
    $(wildcard include/config/HOTPLUG_CORE_SYNC_DEAD) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/static_call.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/text-patching.h \
    $(wildcard include/config/UML_X86) \
  /home/jacob/contest/linux-6.6.1/include/linux/sched/clock.h \
    $(wildcard include/config/ARCH_WANTS_NO_INSTR) \
    $(wildcard include/config/GENERIC_SCHED_CLOCK) \
    $(wildcard include/config/HAVE_UNSTABLE_SCHED_CLOCK) \
  /home/jacob/contest/linux-6.6.1/include/linux/set_memory.h \
    $(wildcard include/config/ARCH_HAS_SET_MEMORY) \
    $(wildcard include/config/ARCH_HAS_SET_DIRECT_MAP) \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/set_memory.h \
  /home/jacob/contest/linux-6.6.1/include/asm-generic/set_memory.h \
  /home/jacob/contest/linux-6.6.1/include/crypto/sha1.h \
  /home/jacob/contest/linux-6.6.1/include/net/sch_generic.h \
  /home/jacob/contest/linux-6.6.1/include/net/gen_stats.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/gen_stats.h \
  /home/jacob/contest/linux-6.6.1/include/net/flow_offload.h \
  /home/jacob/contest/linux-6.6.1/include/net/mptcp.h \
    $(wildcard include/config/MPTCP_IPV6) \
  /home/jacob/contest/linux-6.6.1/include/linux/bpf-cgroup.h \
  /home/jacob/contest/linux-6.6.1/include/net/netfilter/ipv6/nf_defrag_ipv6.h \
  /home/jacob/contest/linux-6.6.1/include/net/ip6_checksum.h \
  /home/jacob/contest/linux-6.6.1/include/net/xfrm.h \
    $(wildcard include/config/XFRM_SUB_POLICY) \
    $(wildcard include/config/NET_PKTGEN) \
    $(wildcard include/config/XFRM_MIGRATE) \
    $(wildcard include/config/XFRM_USER_COMPAT) \
    $(wildcard include/config/XFRM_INTERFACE) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/pfkeyv2.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/ipsec.h \
  /home/jacob/contest/linux-6.6.1/include/linux/audit.h \
    $(wildcard include/config/AUDIT_COMPAT_GENERIC) \
  /home/jacob/contest/linux-6.6.1/include/linux/ptrace.h \
  /home/jacob/contest/linux-6.6.1/include/linux/pid_namespace.h \
    $(wildcard include/config/MEMFD_CREATE) \
    $(wildcard include/config/PID_NS) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/ptrace.h \
  /home/jacob/contest/linux-6.6.1/include/linux/audit_arch.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/audit.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netfilter/nf_tables.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/fanotify.h \
  /home/jacob/contest/linux-6.6.1/arch/x86/include/asm/syscall.h \
  /home/jacob/contest/linux-6.6.1/include/net/netfilter/nf_conntrack_core.h \
  /home/jacob/contest/linux-6.6.1/include/net/netfilter/nf_conntrack_ecache.h \
  /home/jacob/contest/linux-6.6.1/include/net/netfilter/nf_conntrack_l4proto.h \
    $(wildcard include/config/NF_CONNTRACK_PROCFS) \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netfilter/nfnetlink_conntrack.h \
  /home/jacob/contest/linux-6.6.1/include/linux/netfilter/nfnetlink.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netfilter/nfnetlink.h \
  /home/jacob/contest/linux-6.6.1/include/uapi/linux/netfilter/nfnetlink_compat.h \

net/netfilter/nf_nat_proto.o: $(deps_net/netfilter/nf_nat_proto.o)

$(deps_net/netfilter/nf_nat_proto.o):
