// SPDX-License-Identifier: GPL-2.0-only
/*
 *  linux/kernel/panic.c
 *
 *  Copyright (C) 1991, 1992  Linus Torvalds
 */

/*
 * This function is used through-out the kernel (including mm and fs)
 * to indicate a major problem.
 */
#include <linux/debug_locks.h>
#include <linux/sched/debug.h>
#include <linux/interrupt.h>
#include <linux/kgdb.h>
#include <linux/kmsg_dump.h>
#include <linux/kallsyms.h>
#include <linux/notifier.h>
#include <linux/vt_kern.h>
#include <linux/module.h>
#include <linux/random.h>
#include <linux/ftrace.h>
#include <linux/reboot.h>
#include <linux/delay.h>
#include <linux/kexec.h>
#include <linux/panic_notifier.h>
#include <linux/sched.h>
#include <linux/string_helpers.h>
#include <linux/sysrq.h>
#include <linux/init.h>
#include <linux/nmi.h>
#include <linux/console.h>
#include <linux/bug.h>
#include <linux/ratelimit.h>
#include <linux/debugfs.h>
#include <linux/sysfs.h>
#include <linux/context_tracking.h>
#include <linux/seq_buf.h>
#include <linux/sys_info.h>
#include <trace/events/error_report.h>
#include <asm/sections.h>

#define PANIC_TIMER_STEP 100
#define PANIC_BLINK_SPD 18

#ifdef CONFIG_SMP
/*
 * Should we dump all CPUs backtraces in an oops event?
 * Defaults to 0, can be changed via sysctl.
 */
static unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
#else
#define sysctl_oops_all_cpu_backtrace 0
#endif /* CONFIG_SMP */

int panic_on_oops = IS_ENABLED(CONFIG_PANIC_ON_OOPS);
static unsigned long tainted_mask = IS_ENABLED(CONFIG_RANDSTRUCT) ? (1 << TAINT_RANDSTRUCT) : 0;
static int pause_on_oops;
static int pause_on_oops_flag;
static DEFINE_SPINLOCK(pause_on_oops_lock);
bool crash_kexec_post_notifiers;
int panic_on_warn __read_mostly;
unsigned long panic_on_taint;
bool panic_on_taint_nousertaint = false;
static unsigned int warn_limit __read_mostly;
static bool panic_console_replay;

bool panic_triggering_all_cpu_backtrace;
static bool panic_this_cpu_backtrace_printed;

int panic_timeout = CONFIG_PANIC_TIMEOUT;
EXPORT_SYMBOL_GPL(panic_timeout);

unsigned long panic_print;

ATOMIC_NOTIFIER_HEAD(panic_notifier_list);

EXPORT_SYMBOL(panic_notifier_list);

static void panic_print_deprecated(void)
{
	pr_info_once("Kernel: The 'panic_print' parameter is now deprecated. Please use 'panic_sys_info' and 'panic_console_replay' instead.\n");
}

#ifdef CONFIG_SYSCTL
static int proc_taint(const struct ctl_table *table, int write, void *buffer, size_t *lenp, loff_t *ppos)
{
    // ... implementation omitted for brevity ...
    return 0;
}
#endif

void __weak __noreturn panic_smp_self_stop(void)
{
	while (1)
		cpu_relax();
}

void __weak __noreturn nmi_panic_self_stop(struct pt_regs *regs)
{
	panic_smp_self_stop();
}

void __weak crash_smp_send_stop(void)
{
	static int cpus_stopped;
	if (cpus_stopped)
		return;
	smp_send_stop();
	cpus_stopped = 1;
}

atomic_t panic_cpu = ATOMIC_INIT(PANIC_CPU_INVALID);

bool panic_try_start(void)
{
	int old_cpu, this_cpu;
	old_cpu = PANIC_CPU_INVALID;
	this_cpu = raw_smp_processor_id();
	return atomic_try_cmpxchg(&panic_cpu, &old_cpu, this_cpu);
}
EXPORT_SYMBOL(panic_try_start);

void panic_reset(void)
{
	atomic_set(&panic_cpu, PANIC_CPU_INVALID);
}
EXPORT_SYMBOL(panic_reset);

bool panic_in_progress(void)
{
	return unlikely(atomic_read(&panic_cpu) != PANIC_CPU_INVALID);
}
EXPORT_SYMBOL(panic_in_progress);

bool panic_on_this_cpu(void)
{
	return unlikely(atomic_read(&panic_cpu) == raw_smp_processor_id());
}
EXPORT_SYMBOL(panic_on_this_cpu);

bool panic_on_other_cpu(void)
{
	return (panic_in_progress() && !panic_on_this_cpu());
}
EXPORT_SYMBOL(panic_on_other_cpu);

void nmi_panic(struct pt_regs *regs, const char *msg)
{
	if (panic_try_start())
		panic("%s", msg);
	else if (panic_on_other_cpu())
		nmi_panic_self_stop(regs);
}
EXPORT_SYMBOL(nmi_panic);

void check_panic_on_warn(const char *origin)
{
	unsigned int limit;

	if (panic_on_warn)
		panic("%s: panic_on_warn set ...\n", origin);

	limit = READ_ONCE(warn_limit);
	if (atomic_inc_return(&warn_count) >= limit && limit)
		panic("%s: system warned too often (kernel.warn_limit is %d)", origin, limit);
}

void vpanic(const char *fmt, va_list args)
{
    // ... simplified ...
    if (panic_on_warn) {
        panic_on_warn = 0;
    }
    // ...
}
EXPORT_SYMBOL(vpanic);

void panic(const char *fmt, ...)
{
	va_list args;
	va_start(args, fmt);
	vpanic(fmt, args);
	va_end(args);
}
EXPORT_SYMBOL(panic);
