	.file	"asm-offsets.c"
# GNU C11 (Ubuntu 13.3.0-6ubuntu2~24.04) version 13.3.0 (x86_64-linux-gnu)
#	compiled by GNU C version 13.3.0, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
#Versions of loaded plugins:
 #analyzer_plugin: Unknown version.
# options passed: -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -m64 -mno-80387 -mno-fp-ret-in-387 -mpreferred-stack-boundary=3 -mskip-rax-setup -mtune=generic -mno-red-zone -mcmodel=kernel -mindirect-branch=thunk-extern -mindirect-branch-register -mindirect-branch-cs-prefix -mfunction-return=thunk-extern -march=x86-64 -O2 -std=gnu11 -fshort-wchar -funsigned-char -fno-common -fno-PIE -fno-strict-aliasing -fcf-protection=branch -falign-jumps=1 -falign-loops=1 -fno-asynchronous-unwind-tables -fno-jump-tables -fpatchable-function-entry=16,16 -fno-delete-null-pointer-checks -fno-allow-store-data-races -fstack-protector-strong -fomit-frame-pointer -ftrivial-auto-var-init=zero -fno-stack-clash-protection -falign-functions=16 -fstrict-flex-arrays=3 -fno-strict-overflow -fstack-check=no -fconserve-stack -fplugin=/home/jacob/contest/src/plugin/analyzer_plugin.so -fstack-protector-strong
	.text
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4624
	.align 8
	.quad	.LPFE4624
	.section	.text.startup
.LPFE4624:
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	.type	main, @function
main:
	endbr64	
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:20: 	BLANK();
#APP
# 20 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->"
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:24: 	OFFSET(KVM_STEAL_TIME_preempted, kvm_steal_time, preempted);
# 24 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->KVM_STEAL_TIME_preempted $16 offsetof(struct kvm_steal_time, preempted)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:25: 	BLANK();
# 25 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->"
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:29: 	ENTRY(bx);
# 29 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_bx $40 offsetof(struct pt_regs, bx)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:30: 	ENTRY(cx);
# 30 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_cx $88 offsetof(struct pt_regs, cx)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:31: 	ENTRY(dx);
# 31 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_dx $96 offsetof(struct pt_regs, dx)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:32: 	ENTRY(sp);
# 32 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_sp $152 offsetof(struct pt_regs, sp)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:33: 	ENTRY(bp);
# 33 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_bp $32 offsetof(struct pt_regs, bp)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:34: 	ENTRY(si);
# 34 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_si $104 offsetof(struct pt_regs, si)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:35: 	ENTRY(di);
# 35 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_di $112 offsetof(struct pt_regs, di)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:36: 	ENTRY(r8);
# 36 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_r8 $72 offsetof(struct pt_regs, r8)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:37: 	ENTRY(r9);
# 37 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_r9 $64 offsetof(struct pt_regs, r9)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:38: 	ENTRY(r10);
# 38 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_r10 $56 offsetof(struct pt_regs, r10)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:39: 	ENTRY(r11);
# 39 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_r11 $48 offsetof(struct pt_regs, r11)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:40: 	ENTRY(r12);
# 40 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_r12 $24 offsetof(struct pt_regs, r12)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:41: 	ENTRY(r13);
# 41 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_r13 $16 offsetof(struct pt_regs, r13)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:42: 	ENTRY(r14);
# 42 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_r14 $8 offsetof(struct pt_regs, r14)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:43: 	ENTRY(r15);
# 43 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_r15 $0 offsetof(struct pt_regs, r15)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:44: 	ENTRY(flags);
# 44 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->pt_regs_flags $144 offsetof(struct pt_regs, flags)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:45: 	BLANK();
# 45 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->"
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:49: 	ENTRY(cr0);
# 49 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->saved_context_cr0 $200 offsetof(struct saved_context, cr0)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:50: 	ENTRY(cr2);
# 50 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->saved_context_cr2 $208 offsetof(struct saved_context, cr2)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:51: 	ENTRY(cr3);
# 51 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->saved_context_cr3 $216 offsetof(struct saved_context, cr3)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:52: 	ENTRY(cr4);
# 52 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->saved_context_cr4 $224 offsetof(struct saved_context, cr4)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:53: 	ENTRY(gdt_desc);
# 53 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->saved_context_gdt_desc $266 offsetof(struct saved_context, gdt_desc)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:54: 	BLANK();
# 54 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->"
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:57: 	BLANK();
# 57 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->"
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:60: 	OFFSET(FIXED_stack_canary, fixed_percpu_data, stack_canary);
# 60 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->FIXED_stack_canary $40 offsetof(struct fixed_percpu_data, stack_canary)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:61: 	BLANK();
# 61 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c" 1
	
.ascii "->"
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets_64.c:64: }
#NO_APP
	xorl	%eax, %eax	#
	jmp	__x86_return_thunk
	.size	main, .-main
	.text
	.p2align 4
	.section	__patchable_function_entries,"awo",@progbits,.LPFE4625
	.align 8
	.quad	.LPFE4625
	.text
.LPFE4625:
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	nop	
	.type	common, @function
common:
	endbr64	
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:36: 	BLANK();
#APP
# 36 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->"
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:37: 	OFFSET(TASK_threadsp, task_struct, thread.sp);
# 37 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TASK_threadsp $2840 offsetof(struct task_struct, thread.sp)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:39: 	OFFSET(TASK_stack_canary, task_struct, stack_canary);
# 39 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TASK_stack_canary $1320 offsetof(struct task_struct, stack_canary)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:42: 	BLANK();
# 42 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->"
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:43: 	OFFSET(pbe_address, pbe, address);
# 43 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->pbe_address $0 offsetof(struct pbe, address)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:44: 	OFFSET(pbe_orig_address, pbe, orig_address);
# 44 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->pbe_orig_address $8 offsetof(struct pbe, orig_address)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:45: 	OFFSET(pbe_next, pbe, next);
# 45 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->pbe_next $16 offsetof(struct pbe, next)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:48: 	BLANK();
# 48 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->"
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:49: 	OFFSET(IA32_SIGCONTEXT_ax, sigcontext_32, ax);
# 49 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->IA32_SIGCONTEXT_ax $44 offsetof(struct sigcontext_32, ax)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:50: 	OFFSET(IA32_SIGCONTEXT_bx, sigcontext_32, bx);
# 50 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->IA32_SIGCONTEXT_bx $32 offsetof(struct sigcontext_32, bx)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:51: 	OFFSET(IA32_SIGCONTEXT_cx, sigcontext_32, cx);
# 51 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->IA32_SIGCONTEXT_cx $40 offsetof(struct sigcontext_32, cx)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:52: 	OFFSET(IA32_SIGCONTEXT_dx, sigcontext_32, dx);
# 52 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->IA32_SIGCONTEXT_dx $36 offsetof(struct sigcontext_32, dx)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:53: 	OFFSET(IA32_SIGCONTEXT_si, sigcontext_32, si);
# 53 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->IA32_SIGCONTEXT_si $20 offsetof(struct sigcontext_32, si)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:54: 	OFFSET(IA32_SIGCONTEXT_di, sigcontext_32, di);
# 54 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->IA32_SIGCONTEXT_di $16 offsetof(struct sigcontext_32, di)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:55: 	OFFSET(IA32_SIGCONTEXT_bp, sigcontext_32, bp);
# 55 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->IA32_SIGCONTEXT_bp $24 offsetof(struct sigcontext_32, bp)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:56: 	OFFSET(IA32_SIGCONTEXT_sp, sigcontext_32, sp);
# 56 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->IA32_SIGCONTEXT_sp $28 offsetof(struct sigcontext_32, sp)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:57: 	OFFSET(IA32_SIGCONTEXT_ip, sigcontext_32, ip);
# 57 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->IA32_SIGCONTEXT_ip $56 offsetof(struct sigcontext_32, ip)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:59: 	BLANK();
# 59 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->"
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:60: 	OFFSET(IA32_RT_SIGFRAME_sigcontext, rt_sigframe_ia32, uc.uc_mcontext);
# 60 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->IA32_RT_SIGFRAME_sigcontext $164 offsetof(struct rt_sigframe_ia32, uc.uc_mcontext)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:70: 	BLANK();
# 70 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->"
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:71: 	OFFSET(TDX_MODULE_rcx, tdx_module_output, rcx);
# 71 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_MODULE_rcx $0 offsetof(struct tdx_module_output, rcx)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:72: 	OFFSET(TDX_MODULE_rdx, tdx_module_output, rdx);
# 72 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_MODULE_rdx $8 offsetof(struct tdx_module_output, rdx)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:73: 	OFFSET(TDX_MODULE_r8,  tdx_module_output, r8);
# 73 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_MODULE_r8 $16 offsetof(struct tdx_module_output, r8)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:74: 	OFFSET(TDX_MODULE_r9,  tdx_module_output, r9);
# 74 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_MODULE_r9 $24 offsetof(struct tdx_module_output, r9)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:75: 	OFFSET(TDX_MODULE_r10, tdx_module_output, r10);
# 75 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_MODULE_r10 $32 offsetof(struct tdx_module_output, r10)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:76: 	OFFSET(TDX_MODULE_r11, tdx_module_output, r11);
# 76 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_MODULE_r11 $40 offsetof(struct tdx_module_output, r11)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:78: 	BLANK();
# 78 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->"
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:79: 	OFFSET(TDX_HYPERCALL_r8,  tdx_hypercall_args, r8);
# 79 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_HYPERCALL_r8 $0 offsetof(struct tdx_hypercall_args, r8)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:80: 	OFFSET(TDX_HYPERCALL_r9,  tdx_hypercall_args, r9);
# 80 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_HYPERCALL_r9 $8 offsetof(struct tdx_hypercall_args, r9)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:81: 	OFFSET(TDX_HYPERCALL_r10, tdx_hypercall_args, r10);
# 81 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_HYPERCALL_r10 $16 offsetof(struct tdx_hypercall_args, r10)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:82: 	OFFSET(TDX_HYPERCALL_r11, tdx_hypercall_args, r11);
# 82 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_HYPERCALL_r11 $24 offsetof(struct tdx_hypercall_args, r11)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:83: 	OFFSET(TDX_HYPERCALL_r12, tdx_hypercall_args, r12);
# 83 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_HYPERCALL_r12 $32 offsetof(struct tdx_hypercall_args, r12)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:84: 	OFFSET(TDX_HYPERCALL_r13, tdx_hypercall_args, r13);
# 84 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_HYPERCALL_r13 $40 offsetof(struct tdx_hypercall_args, r13)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:85: 	OFFSET(TDX_HYPERCALL_r14, tdx_hypercall_args, r14);
# 85 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_HYPERCALL_r14 $48 offsetof(struct tdx_hypercall_args, r14)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:86: 	OFFSET(TDX_HYPERCALL_r15, tdx_hypercall_args, r15);
# 86 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_HYPERCALL_r15 $56 offsetof(struct tdx_hypercall_args, r15)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:87: 	OFFSET(TDX_HYPERCALL_rdi, tdx_hypercall_args, rdi);
# 87 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_HYPERCALL_rdi $64 offsetof(struct tdx_hypercall_args, rdi)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:88: 	OFFSET(TDX_HYPERCALL_rsi, tdx_hypercall_args, rsi);
# 88 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_HYPERCALL_rsi $72 offsetof(struct tdx_hypercall_args, rsi)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:89: 	OFFSET(TDX_HYPERCALL_rbx, tdx_hypercall_args, rbx);
# 89 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_HYPERCALL_rbx $80 offsetof(struct tdx_hypercall_args, rbx)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:90: 	OFFSET(TDX_HYPERCALL_rdx, tdx_hypercall_args, rdx);
# 90 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TDX_HYPERCALL_rdx $88 offsetof(struct tdx_hypercall_args, rdx)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:92: 	BLANK();
# 92 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->"
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:93: 	OFFSET(BP_scratch, boot_params, scratch);
# 93 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->BP_scratch $484 offsetof(struct boot_params, scratch)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:94: 	OFFSET(BP_secure_boot, boot_params, secure_boot);
# 94 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->BP_secure_boot $492 offsetof(struct boot_params, secure_boot)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:95: 	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
# 95 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->BP_loadflags $529 offsetof(struct boot_params, hdr.loadflags)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:96: 	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
# 96 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->BP_hardware_subarch $572 offsetof(struct boot_params, hdr.hardware_subarch)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:97: 	OFFSET(BP_version, boot_params, hdr.version);
# 97 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->BP_version $518 offsetof(struct boot_params, hdr.version)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:98: 	OFFSET(BP_kernel_alignment, boot_params, hdr.kernel_alignment);
# 98 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->BP_kernel_alignment $560 offsetof(struct boot_params, hdr.kernel_alignment)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:99: 	OFFSET(BP_init_size, boot_params, hdr.init_size);
# 99 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->BP_init_size $608 offsetof(struct boot_params, hdr.init_size)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:100: 	OFFSET(BP_pref_address, boot_params, hdr.pref_address);
# 100 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->BP_pref_address $600 offsetof(struct boot_params, hdr.pref_address)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:102: 	BLANK();
# 102 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->"
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:103: 	DEFINE(PTREGS_SIZE, sizeof(struct pt_regs));
# 103 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->PTREGS_SIZE $168 sizeof(struct pt_regs)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:106: 	OFFSET(TLB_STATE_user_pcid_flush_mask, tlb_state, user_pcid_flush_mask);
# 106 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TLB_STATE_user_pcid_flush_mask $22 offsetof(struct tlb_state, user_pcid_flush_mask)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:109: 	OFFSET(CPU_ENTRY_AREA_entry_stack, cpu_entry_area, entry_stack_page);
# 109 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->CPU_ENTRY_AREA_entry_stack $4096 offsetof(struct cpu_entry_area, entry_stack_page)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:110: 	DEFINE(SIZEOF_entry_stack, sizeof(struct entry_stack));
# 110 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->SIZEOF_entry_stack $4096 sizeof(struct entry_stack)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:111: 	DEFINE(MASK_entry_stack, (~(sizeof(struct entry_stack) - 1)));
# 111 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->MASK_entry_stack $-4096 (~(sizeof(struct entry_stack) - 1))"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:114: 	OFFSET(TSS_sp0, tss_struct, x86_tss.sp0);
# 114 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TSS_sp0 $4 offsetof(struct tss_struct, x86_tss.sp0)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:115: 	OFFSET(TSS_sp1, tss_struct, x86_tss.sp1);
# 115 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TSS_sp1 $12 offsetof(struct tss_struct, x86_tss.sp1)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:116: 	OFFSET(TSS_sp2, tss_struct, x86_tss.sp2);
# 116 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->TSS_sp2 $20 offsetof(struct tss_struct, x86_tss.sp2)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:117: 	OFFSET(X86_top_of_stack, pcpu_hot, top_of_stack);
# 117 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->X86_top_of_stack $24 offsetof(struct pcpu_hot, top_of_stack)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:118: 	OFFSET(X86_current_task, pcpu_hot, current_task);
# 118 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->X86_current_task $0 offsetof(struct pcpu_hot, current_task)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:120: 	OFFSET(X86_call_depth, pcpu_hot, call_depth);
# 120 "/home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c" 1
	
.ascii "->X86_call_depth $16 offsetof(struct pcpu_hot, call_depth)"	#
# 0 "" 2
# /home/jacob/contest/linux-6.6.1/arch/x86/kernel/asm-offsets.c:130: }
#NO_APP
	jmp	__x86_return_thunk
	.size	common, .-common
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x1
3:
	.align 8
4:
