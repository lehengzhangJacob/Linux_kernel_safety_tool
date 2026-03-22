#include "leak_detector.h"
#include <gimple.h>
#include <gimple-iterator.h>
#include <tree.h>
#include <string.h>
#include <algorithm>

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

    static std::set<std::string> log_functions = {
        "printk", "pr_info", "pr_warn", "pr_err", "pr_debug",
        "dev_info", "dev_warn", "dev_err", "dev_dbg",
        "netdev_info", "netdev_warn", "netdev_err",
        "dprintk", "vprintk",
        "printf", "fprintf", "sprintf", "snprintf",
        "syslog", "syslog_printk"
    };

    return log_functions.count(fname) > 0;
}

bool InfoLeakDetector::is_error_output(gimple *stmt) {
    if (!stmt || !is_gimple_call(stmt)) return false;

    tree fn = gimple_call_fndecl(stmt);
    if (!fn) return false;

    const char* name = IDENTIFIER_POINTER(DECL_NAME(fn));
    if (!name) return false;

    std::string fname(name);
    std::transform(fname.begin(), fname.end(), fname.begin(), ::tolower);

    static std::set<std::string> error_functions = {
        "warn", "warning", "error", "err",
        "panic", "bug", "dump_stack",
        "WARN_ON", "BUG_ON", "WARN_ON_ONCE"
    };

    return error_functions.count(fname) > 0;
}

bool InfoLeakDetector::is_network_output(gimple *stmt) {
    if (!stmt || !is_gimple_call(stmt)) return false;

    tree fn = gimple_call_fndecl(stmt);
    if (!fn) return false;

    const char* name = IDENTIFIER_POINTER(DECL_NAME(fn));
    if (!name) return false;

    std::string fname(name);
    std::transform(fname.begin(), fname.end(), fname.begin(), ::tolower);

    static std::set<std::string> network_functions = {
        "send", "sendto", "sendmsg", "sendmmsg",
        "write", "writev", "pwrite", "pwritev",
        "sys_write", "sys_send", "sys_sendto", "sys_sendmsg",
        "tcp_sendmsg", "udp_sendmsg", "sock_sendmsg",
        "net_sendmsg", "net_write", "ip_send_skb",
        "sk_sendmsg", "sk_write", "sock_write"
    };

    return network_functions.count(fname) > 0;
}

bool InfoLeakDetector::is_file_output(gimple *stmt) {
    if (!stmt || !is_gimple_call(stmt)) return false;

    tree fn = gimple_call_fndecl(stmt);
    if (!fn) return false;

    const char* name = IDENTIFIER_POINTER(DECL_NAME(fn));
    if (!name) return false;

    std::string fname(name);
    std::transform(fname.begin(), fname.end(), fname.begin(), ::tolower);

    static std::set<std::string> file_functions = {
        "fwrite", "fprintf", "fputs", "fputc",
        "write", "writev", "pwrite", "pwritev",
        "sys_write", "sys_pwrite", "filp_write",
        "vfs_write", "vfs_pwrite", "kernel_write",
        "file_write", "file_putc", "file_puts"
    };

    return file_functions.count(fname) > 0;
}

void InfoLeakDetector::check_log_output(gimple *stmt) {
    if (!is_log_function(stmt) && !is_error_output(stmt) && 
        !is_network_output(stmt) && !is_file_output(stmt)) return;

    for (unsigned i = 0; i < gimple_call_num_args(stmt); i++) {
        tree arg = gimple_call_arg(stmt, i);
        if (!arg) continue;

        tree arg_val = arg;
        if (TREE_CODE(arg) == ADDR_EXPR) {
            arg_val = TREE_OPERAND(arg, 0);
        }

        // 检查敏感变量
        if (DECL_P(arg_val) && sensitive_vars.count(arg_val) > 0) {
            std::string var_name = sensitive_vars[arg_val];
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

                if (lhs && DECL_P(lhs)) {
                    track_sensitive_data_flow(lhs, bb);
                }

                if (rhs1 && DECL_P(rhs1)) {
                    track_sensitive_data_flow(rhs1, bb);
                }
            }

            // Check for sensitive data in function parameters
            if (is_gimple_call(stmt)) {
                for (unsigned i = 0; i < gimple_call_num_args(stmt); i++) {
                    tree arg = gimple_call_arg(stmt, i);
                    if (arg && DECL_P(arg)) {
                        track_sensitive_data_flow(arg, bb);
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