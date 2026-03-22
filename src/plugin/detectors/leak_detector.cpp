#include "leak_detector.h"
#if __has_include(<gimple.h>)
#include <gimple.h>
#elif __has_include("/usr/lib/gcc/x86_64-linux-gnu/13/plugin/include/gimple.h")
#include "/usr/lib/gcc/x86_64-linux-gnu/13/plugin/include/gimple.h"
#endif

#if __has_include(<gimple-iterator.h>)
#include <gimple-iterator.h>
#elif __has_include("/usr/lib/gcc/x86_64-linux-gnu/13/plugin/include/gimple-iterator.h")
#include "/usr/lib/gcc/x86_64-linux-gnu/13/plugin/include/gimple-iterator.h"
#endif

#if __has_include(<tree.h>)
#include <tree.h>
#elif __has_include("/usr/lib/gcc/x86_64-linux-gnu/13/plugin/include/tree.h")
#include "/usr/lib/gcc/x86_64-linux-gnu/13/plugin/include/tree.h"
#endif
#include <string.h>
#include <algorithm>
#include <vector>

// -----------------------------------------------------------------------------
// InfoLeakDetector Implementation
// -----------------------------------------------------------------------------

void InfoLeakDetector::initialize() {
    initialize_patterns();
    sensitive_vars.clear();
    fprintf(stdout, "[InfoLeakDetector] Initialized with %zu sensitive patterns\n", 
            sensitive_patterns.size());
}

void InfoLeakDetector::initialize_patterns() {
    sensitive_patterns.clear();

    // Password related
    sensitive_patterns.insert("password");
    sensitive_patterns.insert("passwd");
    sensitive_patterns.insert("pwd");
    sensitive_patterns.insert("pass");
    sensitive_patterns.insert("secret");
    sensitive_patterns.insert("pwd_hash");
    sensitive_patterns.insert("password_hash");
    sensitive_patterns.insert("pass_hash");
    sensitive_patterns.insert("cred");
    sensitive_patterns.insert("credentials");

    // Key related
    sensitive_patterns.insert("key");
    sensitive_patterns.insert("private_key");
    sensitive_patterns.insert("public_key");
    sensitive_patterns.insert("api_key");
    sensitive_patterns.insert("secret_key");
    sensitive_patterns.insert("encryption_key");
    sensitive_patterns.insert("decryption_key");
    sensitive_patterns.insert("signing_key");
    sensitive_patterns.insert("verification_key");
    sensitive_patterns.insert("ssh_key");
    sensitive_patterns.insert("gpg_key");

    // Token related
    sensitive_patterns.insert("token");
    sensitive_patterns.insert("auth_token");
    sensitive_patterns.insert("session_token");
    sensitive_patterns.insert("access_token");
    sensitive_patterns.insert("refresh_token");
    sensitive_patterns.insert("csrf_token");
    sensitive_patterns.insert("jwt_token");
    sensitive_patterns.insert("oauth_token");
    sensitive_patterns.insert("api_token");
    sensitive_patterns.insert("device_token");

    // User information
    sensitive_patterns.insert("credit_card");
    sensitive_patterns.insert("ssn");
    sensitive_patterns.insert("id_number");
    sensitive_patterns.insert("social_security");
    sensitive_patterns.insert("national_id");
    sensitive_patterns.insert("passport");
    sensitive_patterns.insert("driver_license");
    sensitive_patterns.insert("bank_account");
    sensitive_patterns.insert("routing_number");
    sensitive_patterns.insert("iban");
    sensitive_patterns.insert("swift");

    // Personal information
    sensitive_patterns.insert("email");
    sensitive_patterns.insert("phone");
    sensitive_patterns.insert("address");
    sensitive_patterns.insert("full_name");
    sensitive_patterns.insert("real_name");
    sensitive_patterns.insert("first_name");
    sensitive_patterns.insert("last_name");
    sensitive_patterns.insert("date_of_birth");
    sensitive_patterns.insert("birth_date");
    sensitive_patterns.insert("age");
    sensitive_patterns.insert("gender");
    sensitive_patterns.insert("marital_status");
    sensitive_patterns.insert("occupation");
    sensitive_patterns.insert("salary");

    // Authentication
    sensitive_patterns.insert("username");
    sensitive_patterns.insert("user");
    sensitive_patterns.insert("auth");
    sensitive_patterns.insert("credential");
    sensitive_patterns.insert("login");
    sensitive_patterns.insert("logout");
    sensitive_patterns.insert("session");
    sensitive_patterns.insert("cookie");
    sensitive_patterns.insert("session_id");
    sensitive_patterns.insert("user_id");
    sensitive_patterns.insert("user_name");

    // Security
    sensitive_patterns.insert("hash");
    sensitive_patterns.insert("salt");
    sensitive_patterns.insert("nonce");
    sensitive_patterns.insert("iv");
    sensitive_patterns.insert("seed");
    sensitive_patterns.insert("random");
    sensitive_patterns.insert("entropy");
    sensitive_patterns.insert("prng");
    sensitive_patterns.insert("cipher");
    sensitive_patterns.insert("encrypt");
    sensitive_patterns.insert("decrypt");
    sensitive_patterns.insert("sign");
    sensitive_patterns.insert("verify");

    // Network
    sensitive_patterns.insert("ip_address");
    sensitive_patterns.insert("mac_address");
    sensitive_patterns.insert("hostname");
    sensitive_patterns.insert("port");
    sensitive_patterns.insert("url");
    sensitive_patterns.insert("uri");
    sensitive_patterns.insert("endpoint");
    sensitive_patterns.insert("path");
    sensitive_patterns.insert("query");
    sensitive_patterns.insert("header");
    sensitive_patterns.insert("cookie");
    sensitive_patterns.insert("user_agent");

    // File system
    sensitive_patterns.insert("file_path");
    sensitive_patterns.insert("file_name");
    sensitive_patterns.insert("directory");
    sensitive_patterns.insert("path");
    sensitive_patterns.insert("filename");
    sensitive_patterns.insert("filepath");
    sensitive_patterns.insert("dir");

    // Environment
    sensitive_patterns.insert("env");
    sensitive_patterns.insert("environment");
    sensitive_patterns.insert("env_var");
    sensitive_patterns.insert("environment_variable");
    sensitive_patterns.insert("config");
    sensitive_patterns.insert("configuration");
    sensitive_patterns.insert("setting");
    sensitive_patterns.insert("option");
}

bool InfoLeakDetector::is_sensitive_data(const std::string& var_name) {
    std::string lower_name = var_name;
    std::transform(lower_name.begin(), lower_name.end(), lower_name.begin(), ::tolower);

    for (const auto& pattern : sensitive_patterns) {
        if (lower_name.find(pattern) != std::string::npos) {
            return true;
        }
    }

    return false;
}

bool InfoLeakDetector::is_sensitive_string(tree expr) {
    if (!expr || TREE_CODE(expr) != STRING_CST) return false;

    const char* str = TREE_STRING_POINTER(expr);
    if (!str) return false;

    std::string lower_str(str);
    std::transform(lower_str.begin(), lower_str.end(), lower_str.begin(), ::tolower);

    // 检查常见的敏感字符串模式
    static std::set<std::string> sensitive_string_patterns = {
        "password", "passwd", "pwd", "secret", "key", "token",
        "api_key", "secret_key", "private_key", "public_key",
        "credit_card", "ssn", "id_number", "social_security",
        "email", "phone", "address", "full_name", "real_name",
        "username", "user", "auth", "credential", "login",
        "session", "cookie", "session_id", "user_id",
        "ip_address", "mac_address", "hostname", "port",
        "url", "uri", "endpoint", "path", "query",
        "header", "user_agent", "file_path", "file_name",
        "directory", "path", "filename", "filepath", "dir",
        "env", "environment", "env_var", "environment_variable",
        "config", "configuration", "setting", "option"
    };

    for (const auto& pattern : sensitive_string_patterns) {
        if (lower_str.find(pattern) != std::string::npos) {
            return true;
        }
    }

    return false;
}

void InfoLeakDetector::track_sensitive_data_flow(tree var, basic_block bb) {
    if (!var || !bb) return;

    std::string var_name;
    if (DECL_P(var) && DECL_NAME(var)) {
        var_name = IDENTIFIER_POINTER(DECL_NAME(var));
    }

    if (is_sensitive_data(var_name)) {
        sensitive_vars[var] = var_name;
    }
}

bool InfoLeakDetector::is_log_function(gimple *stmt) {
    if (!stmt || !is_gimple_call(stmt)) return false;

    tree fn = gimple_call_fndecl(stmt);
    if (!fn) return false;

    const char* name = IDENTIFIER_POINTER(DECL_NAME(fn));
    if (!name) return false;

    std::string fname(name);
    std::transform(fname.begin(), fname.end(), fname.begin(), ::tolower);

    static const std::vector<std::string> log_keywords = {
        "printk", "pr_", "dev_", "netdev_", "dprintk", "vprintk",
        "printf", "fprintf", "sprintf", "snprintf", "seq_printf", "trace_printk", "syslog"
    };

    for (const auto& kw : log_keywords) {
        if (fname.find(kw) != std::string::npos) {
            return true;
        }
    }

    return false;
}

bool InfoLeakDetector::is_error_output(gimple *stmt) {
    if (!stmt || !is_gimple_call(stmt)) return false;

    tree fn = gimple_call_fndecl(stmt);
    if (!fn) return false;

    const char* name = IDENTIFIER_POINTER(DECL_NAME(fn));
    if (!name) return false;

    std::string fname(name);
    std::transform(fname.begin(), fname.end(), fname.begin(), ::tolower);

    static const std::vector<std::string> error_keywords = {
        "warn", "warning", "error", "err", "panic", "bug", "oops", "dump_stack"
    };

    for (const auto& kw : error_keywords) {
        if (fname.find(kw) != std::string::npos) {
            return true;
        }
    }

    return false;
}

bool InfoLeakDetector::is_network_output(gimple *stmt) {
    if (!stmt || !is_gimple_call(stmt)) return false;

    tree fn = gimple_call_fndecl(stmt);
    if (!fn) return false;

    const char* name = IDENTIFIER_POINTER(DECL_NAME(fn));
    if (!name) return false;

    std::string fname(name);
    std::transform(fname.begin(), fname.end(), fname.begin(), ::tolower);

    static const std::vector<std::string> network_keywords = {
        "send", "sendto", "sendmsg", "sendmmsg", "sock_send", "tcp_send", "udp_send",
        "ip_send", "net_send", "xmit", "transmit", "copy_to_user", "put_user"
    };

    for (const auto& kw : network_keywords) {
        if (fname.find(kw) != std::string::npos) {
            return true;
        }
    }

    return false;
}

bool InfoLeakDetector::is_file_output(gimple *stmt) {
    if (!stmt || !is_gimple_call(stmt)) return false;

    tree fn = gimple_call_fndecl(stmt);
    if (!fn) return false;

    const char* name = IDENTIFIER_POINTER(DECL_NAME(fn));
    if (!name) return false;

    std::string fname(name);
    std::transform(fname.begin(), fname.end(), fname.begin(), ::tolower);

    static const std::vector<std::string> file_keywords = {
        "fwrite", "fprintf", "fputs", "fputc", "write", "pwrite", "writev",
        "filp_write", "vfs_write", "kernel_write", "seq_write", "proc_write",
        "sys_write", "copy_from_user"
    };

    for (const auto& kw : file_keywords) {
        if (fname.find(kw) != std::string::npos) {
            return true;
        }
    }

    return false;
}

void InfoLeakDetector::check_log_output(gimple *stmt) {
    if (!is_log_function(stmt) && !is_error_output(stmt) && 
        !is_network_output(stmt) && !is_file_output(stmt)) return;

    auto is_pointer_format_leak = [](tree expr) -> bool {
        tree v = expr;
        if (!v) return false;
        if (TREE_CODE(v) == ADDR_EXPR) {
            v = TREE_OPERAND(v, 0);
        }
        if (!v || TREE_CODE(v) != STRING_CST) return false;

        const char* fmt = TREE_STRING_POINTER(v);
        if (!fmt) return false;

        std::string lower_fmt(fmt);
        std::transform(lower_fmt.begin(), lower_fmt.end(), lower_fmt.begin(), ::tolower);
        return lower_fmt.find("%p") != std::string::npos;
    };

    bool reported_pointer_fmt = false;

    for (unsigned i = 0; i < gimple_call_num_args(stmt); i++) {
        tree arg = gimple_call_arg(stmt, i);
        if (!arg) continue;

        auto extract_name = [](tree expr) -> std::string {
            if (!expr) return "";

            tree v = expr;
            if (TREE_CODE(v) == ADDR_EXPR) {
                v = TREE_OPERAND(v, 0);
            }

            if (TREE_CODE(v) == SSA_NAME) {
                tree ssa_var = SSA_NAME_VAR(v);
                if (ssa_var) {
                    v = ssa_var;
                }
            }

            if (DECL_P(v) && DECL_NAME(v)) {
                return std::string(IDENTIFIER_POINTER(DECL_NAME(v)));
            }

            if (TREE_CODE(v) == COMPONENT_REF) {
                tree field = TREE_OPERAND(v, 1);
                if (field && DECL_P(field) && DECL_NAME(field)) {
                    return std::string(IDENTIFIER_POINTER(DECL_NAME(field)));
                }
            }

            return "";
        };

        std::string arg_name = extract_name(arg);
        std::string lower_arg_name = arg_name;
        std::transform(lower_arg_name.begin(), lower_arg_name.end(), lower_arg_name.begin(), ::tolower);

        bool sensitive_arg = false;
        if (!arg_name.empty() && is_sensitive_data(arg_name)) {
            sensitive_arg = true;
        }

        // 检查敏感变量
        if (!sensitive_arg) {
            tree lookup = arg;
            if (TREE_CODE(lookup) == ADDR_EXPR) {
                lookup = TREE_OPERAND(lookup, 0);
            }
            if (TREE_CODE(lookup) == SSA_NAME && SSA_NAME_VAR(lookup)) {
                lookup = SSA_NAME_VAR(lookup);
            }

            if (lookup && sensitive_vars.count(lookup) > 0) {
                sensitive_arg = true;
                arg_name = sensitive_vars[lookup];
            }
        }

        if (sensitive_arg) {
            std::string var_name = arg_name.empty() ? "sensitive_data" : arg_name;
            expanded_location loc;
            loc = expand_location(gimple_location(stmt));

            std::string output_type;
            if (is_log_function(stmt)) output_type = "log";
            else if (is_error_output(stmt)) output_type = "error output";
            else if (is_network_output(stmt)) output_type = "network";
            else if (is_file_output(stmt)) output_type = "file";
            else output_type = "output";

            std::string severity = is_error_output(stmt) || is_network_output(stmt) ? "High" : "Medium";
            std::string msg = "Sensitive data '" + var_name + "' may be leaked to " + output_type;

            add_result("InfoLeak", severity, msg, loc.line, loc.column,
                      "Avoid leaking sensitive data; consider redaction or hashing");
        }

        // 检查敏感字符串
        if (is_sensitive_string(arg)) {
            expanded_location loc;
            loc = expand_location(gimple_location(stmt));

            std::string output_type;
            if (is_log_function(stmt)) output_type = "log";
            else if (is_error_output(stmt)) output_type = "error output";
            else if (is_network_output(stmt)) output_type = "network";
            else if (is_file_output(stmt)) output_type = "file";
            else output_type = "output";

            std::string severity = is_error_output(stmt) || is_network_output(stmt) ? "High" : "Medium";
            std::string msg = "Potential sensitive data may be leaked to " + output_type;

            add_result("InfoLeak", severity, msg, loc.line, loc.column,
                      "Avoid hardcoding sensitive data; use environment variables or configuration files");
        }

        // 内核常见信息泄露：日志/错误输出直接打印指针地址（%p 及其变体）。
        if (!reported_pointer_fmt && (is_log_function(stmt) || is_error_output(stmt)) && is_pointer_format_leak(arg)) {
            expanded_location loc;
            loc = expand_location(gimple_location(stmt));
            add_result(
                "InfoLeak", "Medium",
                "Potential kernel pointer address leakage via format string (%p)",
                loc.line, loc.column,
                "Use pointer hashing/obfuscation (e.g., %pK) and avoid exposing raw addresses"
            );
            reported_pointer_fmt = true;
        }
    }
}

void InfoLeakDetector::analyze_function(tree fndecl) {
    set_current_function(fndecl);

    if (!fndecl || !DECL_STRUCT_FUNCTION(fndecl)) return;

    sensitive_vars.clear();
    push_cfun(DECL_STRUCT_FUNCTION(fndecl));

    basic_block bb;
    gimple_stmt_iterator gsi;

    FOR_EACH_BB_FN(bb, cfun) {
        for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
            gimple *stmt = gsi_stmt(gsi);

            // Track sensitive data assignments
            if (is_gimple_assign(stmt)) {
                tree lhs = gimple_assign_lhs(stmt);
                tree rhs1 = gimple_assign_rhs1(stmt);

                if (lhs) {
                    tree lhs_var = lhs;
                    if (TREE_CODE(lhs_var) == SSA_NAME && SSA_NAME_VAR(lhs_var)) {
                        lhs_var = SSA_NAME_VAR(lhs_var);
                    }
                    if (TREE_CODE(lhs_var) == COMPONENT_REF) {
                        tree field = TREE_OPERAND(lhs_var, 1);
                        if (field && DECL_P(field)) {
                            track_sensitive_data_flow(field, bb);
                        }
                    }
                    if (lhs_var && DECL_P(lhs_var)) {
                        track_sensitive_data_flow(lhs_var, bb);
                    }
                }

                if (rhs1) {
                    tree rhs_var = rhs1;
                    if (TREE_CODE(rhs_var) == SSA_NAME && SSA_NAME_VAR(rhs_var)) {
                        rhs_var = SSA_NAME_VAR(rhs_var);
                    }
                    if (TREE_CODE(rhs_var) == COMPONENT_REF) {
                        tree field = TREE_OPERAND(rhs_var, 1);
                        if (field && DECL_P(field)) {
                            track_sensitive_data_flow(field, bb);
                        }
                    }
                    if (rhs_var && DECL_P(rhs_var)) {
                        track_sensitive_data_flow(rhs_var, bb);
                    }
                }
            }

            // Check for sensitive data in function parameters
            if (is_gimple_call(stmt)) {
                for (unsigned i = 0; i < gimple_call_num_args(stmt); i++) {
                    tree arg = gimple_call_arg(stmt, i);
                    if (!arg) continue;

                    tree arg_var = arg;
                    if (TREE_CODE(arg_var) == ADDR_EXPR) {
                        arg_var = TREE_OPERAND(arg_var, 0);
                    }
                    if (TREE_CODE(arg_var) == SSA_NAME && SSA_NAME_VAR(arg_var)) {
                        arg_var = SSA_NAME_VAR(arg_var);
                    }
                    if (TREE_CODE(arg_var) == COMPONENT_REF) {
                        tree field = TREE_OPERAND(arg_var, 1);
                        if (field && DECL_P(field)) {
                            track_sensitive_data_flow(field, bb);
                        }
                    }

                    if (arg_var && DECL_P(arg_var)) {
                        track_sensitive_data_flow(arg_var, bb);
                    }
                }
            }

            // Check for information leakage
            check_log_output(stmt);
        }
    }

    pop_cfun();
}

void InfoLeakDetector::finalize() {
    fprintf(stdout, "[InfoLeakDetector] Found %zu information leakage issues\n", results.size());
}