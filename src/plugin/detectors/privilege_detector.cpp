#include "privilege_detector.h"
#include <gimple.h>
#include <gimple-iterator.h>
#include <tree.h>
#include <string.h>
#include <algorithm>

// -----------------------------------------------------------------------------
// PrivilegeEscalationDetector Implementation
// -----------------------------------------------------------------------------

void PrivilegeEscalationDetector::initialize() {
    initialize_syscalls();
    privileged_call_sites.clear();
    fprintf(stdout, "[PrivilegeEscalationDetector] Initialized with %zu privileged syscalls\n",
            privileged_syscalls.size());
}

void PrivilegeEscalationDetector::initialize_syscalls() {
    privileged_syscalls.clear();

    // UID/GID manipulation
    privileged_syscalls.insert("setuid");
    privileged_syscalls.insert("setgid");
    privileged_syscalls.insert("seteuid");
    privileged_syscalls.insert("setegid");
    privileged_syscalls.insert("setreuid");
    privileged_syscalls.insert("setregid");
    privileged_syscalls.insert("setresuid");
    privileged_syscalls.insert("setresgid");
    privileged_syscalls.insert("setfsuid");
    privileged_syscalls.insert("setfsgid");
    privileged_syscalls.insert("getuid");
    privileged_syscalls.insert("getgid");
    privileged_syscalls.insert("geteuid");
    privileged_syscalls.insert("getegid");
    privileged_syscalls.insert("getresuid");
    privileged_syscalls.insert("getresgid");
    privileged_syscalls.insert("getfsuid");
    privileged_syscalls.insert("getfsgid");

    // Capabilities
    privileged_syscalls.insert("capset");
    privileged_syscalls.insert("capget");
    privileged_syscalls.insert("prctl");
    privileged_syscalls.insert("capable");
    privileged_syscalls.insert("ns_capable");
    privileged_syscalls.insert("has_capability");

    // File system
    privileged_syscalls.insert("chown");
    privileged_syscalls.insert("fchown");
    privileged_syscalls.insert("lchown");
    privileged_syscalls.insert("chroot");
    privileged_syscalls.insert("pivot_root");
    privileged_syscalls.insert("mount");
    privileged_syscalls.insert("umount");
    privileged_syscalls.insert("mount_ns");
    privileged_syscalls.insert("umount2");
    privileged_syscalls.insert("mkdir");
    privileged_syscalls.insert("rmdir");
    privileged_syscalls.insert("unlink");
    privileged_syscalls.insert("rmdir");
    privileged_syscalls.insert("link");
    privileged_syscalls.insert("symlink");
    privileged_syscalls.insert("rename");
    privileged_syscalls.insert("mknod");
    privileged_syscalls.insert("mknodat");
    privileged_syscalls.insert("chmod");
    privileged_syscalls.insert("fchmod");
    privileged_syscalls.insert("fchmodat");
    privileged_syscalls.insert("chattr");
    privileged_syscalls.insert("fchattr");

    // Process control
    privileged_syscalls.insert("ptrace");
    privileged_syscalls.insert("kill");
    privileged_syscalls.insert("setsid");
    privileged_syscalls.insert("clone");
    privileged_syscalls.insert("fork");
    privileged_syscalls.insert("vfork");
    privileged_syscalls.insert("execve");
    privileged_syscalls.insert("execveat");
    privileged_syscalls.insert("exit");
    privileged_syscalls.insert("exit_group");

    // I/O privileges
    privileged_syscalls.insert("iopl");
    privileged_syscalls.insert("ioperm");
    privileged_syscalls.insert("inb");
    privileged_syscalls.insert("inw");
    privileged_syscalls.insert("inl");
    privileged_syscalls.insert("outb");
    privileged_syscalls.insert("outw");
    privileged_syscalls.insert("outl");

    // System
    privileged_syscalls.insert("reboot");
    privileged_syscalls.insert("kexec_load");
    privileged_syscalls.insert("sysctl");
    privileged_syscalls.insert("sysfs");
    privileged_syscalls.insert("sethostname");
    privileged_syscalls.insert("setdomainname");
    privileged_syscalls.insert("unshare");
    privileged_syscalls.insert("setns");

    // Network
    privileged_syscalls.insert("setsockopt");
    privileged_syscalls.insert("bind");
    privileged_syscalls.insert("socket");
    privileged_syscalls.insert("socketpair");
    privileged_syscalls.insert("listen");
    privileged_syscalls.insert("accept");
    privileged_syscalls.insert("accept4");
    privileged_syscalls.insert("connect");
    privileged_syscalls.insert("sendto");
    privileged_syscalls.insert("sendmsg");
    privileged_syscalls.insert("recvfrom");
    privileged_syscalls.insert("recvmsg");
    privileged_syscalls.insert("getsockname");
    privileged_syscalls.insert("getpeername");
    privileged_syscalls.insert("getsockopt");

    // Security
    privileged_syscalls.insert("seccomp");
    privileged_syscalls.insert("secureexec");
    privileged_syscalls.insert("getpid");
    privileged_syscalls.insert("getppid");
    privileged_syscalls.insert("getpgid");
    privileged_syscalls.insert("setpgid");
    privileged_syscalls.insert("getsid");
    privileged_syscalls.insert("setsid");
    privileged_syscalls.insert("getpriority");
    privileged_syscalls.insert("setpriority");

    // Time
    privileged_syscalls.insert("settimeofday");
    privileged_syscalls.insert("stime");
    privileged_syscalls.insert("adjtimex");
    privileged_syscalls.insert("clock_settime");
}

bool PrivilegeEscalationDetector::is_privileged_syscall(const std::string& name) {
    std::string lower_name = name;
    std::transform(lower_name.begin(), lower_name.end(), lower_name.begin(), ::tolower);

    return privileged_syscalls.count(lower_name) > 0;
}

bool PrivilegeEscalationDetector::is_privileged_var(tree var) {
    if (!var || !DECL_P(var)) return false;

    const char* name = IDENTIFIER_POINTER(DECL_NAME(var));
    if (!name) return false;

    std::string var_name(name);
    std::transform(var_name.begin(), var_name.end(), var_name.begin(), ::tolower);

    static std::set<std::string> privileged_vars = {
        "uid", "gid", "euid", "egid",
        "suid", "sgid", "fsuid", "fsgid",
        "cap_effective", "cap_inheritable", "cap_permitted",
        "cap_bset", "securebits"
    };

    return privileged_vars.count(var_name) > 0;
}

bool PrivilegeEscalationDetector::has_permission_check(tree var, basic_block bb) {
    if (!var || !bb) return false;

    gimple_stmt_iterator gsi;
    for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
        gimple *stmt = gsi_stmt(gsi);

        if (gimple_code(stmt) == GIMPLE_COND) {
            tree_code cond_code = gimple_cond_code(stmt);
            tree op0 = gimple_cond_lhs(stmt);
            tree op1 = gimple_cond_rhs(stmt);

            if (cond_code == EQ_EXPR || cond_code == NE_EXPR) {
                if ((op0 == var && integer_zerop(op1)) ||
                    (op1 == var && integer_zerop(op0))) {
                    return true;
                }
            }
        }

        if (is_gimple_call(stmt)) {
            tree fn = gimple_call_fndecl(stmt);
            if (fn) {
                const char* name = IDENTIFIER_POINTER(DECL_NAME(fn));
                if (name) {
                    std::string fname(name);
                    std::transform(fname.begin(), fname.end(), fname.begin(), ::tolower);
                    if (fname.find("capable") != std::string::npos ||
                        fname.find("ns_capable") != std::string::npos ||
                        fname.find("has_capability") != std::string::npos ||
                        fname.find("security") != std::string::npos ||
                        fname.find("check") != std::string::npos ||
                        fname.find("verify") != std::string::npos ||
                        fname.find("validate") != std::string::npos) {
                        return true;
                    }
                }
            }
        }
    }

    return false;
}

void PrivilegeEscalationDetector::check_permission_check(gimple *stmt) {
    if (!stmt || !is_gimple_assign(stmt)) return;

    tree lhs = gimple_assign_lhs(stmt);
    tree rhs1 = gimple_assign_rhs1(stmt);

    if (!lhs || !rhs1) return;

    if (is_privileged_var(lhs)) {
        basic_block bb = gimple_bb(stmt);
        if (!has_permission_check(lhs, bb)) {
            expanded_location loc;
            loc = expand_location(gimple_location(stmt));

            std::string var_name;
            if (DECL_P(lhs) && DECL_NAME(lhs)) {
                var_name = IDENTIFIER_POINTER(DECL_NAME(lhs));
            }

            add_result("PrivilegeEscalation", "High",
                       "Assignment to privileged variable '" + var_name + "' without permission check",
                       loc.line, loc.column,
                       "Add permission check before assigning to privileged variable");
        }
    }
}

void PrivilegeEscalationDetector::check_syscall(gimple *stmt) {
    if (!stmt || !is_gimple_call(stmt)) return;

    tree fn = gimple_call_fndecl(stmt);
    if (!fn) return;

    const char* name = IDENTIFIER_POINTER(DECL_NAME(fn));
    if (!name) return;

    if (is_privileged_syscall(name)) {
        privileged_call_sites.insert(stmt);

        // Check if there's a permission check before this call
        basic_block bb = gimple_bb(stmt);
        bool has_check = false;

        gimple_stmt_iterator gsi;
        for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
            gimple *s = gsi_stmt(gsi);
            if (s == stmt) break;

            if (is_gimple_call(s)) {
                tree callee = gimple_call_fndecl(s);
                if (callee) {
                    const char* callee_name = IDENTIFIER_POINTER(DECL_NAME(callee));
                    if (callee_name) {
                        std::string fname(callee_name);
                        std::transform(fname.begin(), fname.end(), fname.begin(), ::tolower);
                        if (fname.find("capable") != std::string::npos ||
                            fname.find("ns_capable") != std::string::npos ||
                            fname.find("has_capability") != std::string::npos ||
                            fname.find("security") != std::string::npos ||
                            fname.find("check") != std::string::npos ||
                            fname.find("verify") != std::string::npos ||
                            fname.find("validate") != std::string::npos) {
                            has_check = true;
                            break;
                        }
                    }
                }
            }

            if (gimple_code(s) == GIMPLE_COND) {
                // Check for UID/GID checks
                tree_code cond_code = gimple_cond_code(s);
                tree op0 = gimple_cond_lhs(s);
                tree op1 = gimple_cond_rhs(s);

                if (cond_code == EQ_EXPR || cond_code == NE_EXPR) {
                    if ((op0 && is_privileged_var(op0) && integer_zerop(op1)) ||
                        (op1 && is_privileged_var(op1) && integer_zerop(op0))) {
                        has_check = true;
                        break;
                    }
                }
            }
        }

        if (!has_check) {
            expanded_location loc;
            loc = expand_location(gimple_location(stmt));

            add_result("PrivilegeEscalation", "High",
                       "Privileged syscall '" + std::string(name) + "' called without permission check",
                       loc.line, loc.column,
                       "Add capability check before calling privileged syscall");
        }
    }
}

void PrivilegeEscalationDetector::analyze_function(tree fndecl) {
    set_current_function(fndecl);

    if (!fndecl || !DECL_STRUCT_FUNCTION(fndecl)) return;

    privileged_call_sites.clear();
    push_cfun(DECL_STRUCT_FUNCTION(fndecl));

    basic_block bb;
    gimple_stmt_iterator gsi;

    FOR_EACH_BB_FN(bb, cfun) {
        for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
            gimple *stmt = gsi_stmt(gsi);

            check_syscall(stmt);
            check_permission_check(stmt);
        }
    }

    pop_cfun();
}

void PrivilegeEscalationDetector::finalize() {
    fprintf(stdout, "[PrivilegeEscalationDetector] Found %zu privilege escalation issues\n", results.size());
}

// -----------------------------------------------------------------------------
// TOCTOUDetector Implementation
// -----------------------------------------------------------------------------

void TOCTOUDetector::initialize() {
    initialize_functions();
    fprintf(stdout, "[TOCTOUDetector] Initialized\n");
}

void TOCTOUDetector::initialize_functions() {
    race_prone_functions.clear();

    // File operations that are race-prone
    race_prone_functions.insert("open");
    race_prone_functions.insert("openat");
    race_prone_functions.insert("stat");
    race_prone_functions.insert("lstat");
    race_prone_functions.insert("fstat");
    race_prone_functions.insert("access");
    race_prone_functions.insert("faccessat");
    race_prone_functions.insert("opendir");
    race_prone_functions.insert("readdir");
}

bool TOCTOUDetector::is_race_prone_function(const std::string& name) {
    std::string lower_name = name;
    std::transform(lower_name.begin(), lower_name.end(), lower_name.begin(), ::tolower);

    return race_prone_functions.count(lower_name) > 0;
}

bool TOCTOUDetector::is_file_operation(gimple *stmt) {
    if (!stmt || !is_gimple_call(stmt)) return false;

    tree fn = gimple_call_fndecl(stmt);
    if (!fn) return false;

    const char* name = IDENTIFIER_POINTER(DECL_NAME(fn));
    if (!name) return false;

    return is_race_prone_function(name);
}

void TOCTOUDetector::check_toctou_pattern(gimple *stmt) {
    if (!stmt || !is_gimple_call(stmt)) return;

    // Check if this is a file operation
    if (!is_file_operation(stmt)) return;

    basic_block bb = gimple_bb(stmt);
    if (!bb) return;

    // Look for the pattern: check() -> use()
    gimple_stmt_iterator gsi;
    bool found_check = false;
    tree checked_var = NULL_TREE;

    for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
        gimple *s = gsi_stmt(gsi);
        if (s == stmt) break;

        // Look for access/stat calls
        if (is_gimple_call(s)) {
            tree fn = gimple_call_fndecl(s);
            if (fn) {
                const char* name = IDENTIFIER_POINTER(DECL_NAME(fn));
                if (name && is_race_prone_function(name)) {
                    found_check = true;
                    // Get the checked variable (usually first argument)
                    if (gimple_call_num_args(s) > 0) {
                        checked_var = gimple_call_arg(s, 0);
                    }
                    break;
                }
            }
        }
    }

    if (found_check && checked_var) {
        // Now look for use of the checked variable
        for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
            gimple *s = gsi_stmt(gsi);

            if (s == stmt) break;

            // Check if the checked variable is used
            if (is_gimple_assign(s)) {
                tree lhs = gimple_assign_lhs(s);
                tree rhs1 = gimple_assign_rhs1(s);

                if ((lhs == checked_var || rhs1 == checked_var)) {
                    expanded_location loc;
                    loc = expand_location(gimple_location(stmt));

                    add_result("TOCTOU", "High",
                               "Potential Time-of-Check-Time-of-Use (TOCTOU) vulnerability",
                               loc.line, loc.column,
                               "Use atomic file operations or re-check after use");
                    break;
                }
            }
        }
    }
}

void TOCTOUDetector::analyze_function(tree fndecl) {
    set_current_function(fndecl);

    if (!fndecl || !DECL_STRUCT_FUNCTION(fndecl)) return;

    push_cfun(DECL_STRUCT_FUNCTION(fndecl));

    basic_block bb;
    gimple_stmt_iterator gsi;

    FOR_EACH_BB_FN(bb, cfun) {
        for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
            gimple *stmt = gsi_stmt(gsi);

            check_toctou_pattern(stmt);
        }
    }

    pop_cfun();
}

void TOCTOUDetector::finalize() {
    fprintf(stdout, "[TOCTOUDetector] Found %zu TOCTOU issues\n", results.size());
}