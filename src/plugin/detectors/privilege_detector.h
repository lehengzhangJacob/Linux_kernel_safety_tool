#ifndef PRIVILEGE_DETECTOR_H
#define PRIVILEGE_DETECTOR_H

#include "detector_base.h"
#include <set>
#include <map>
#include <string>

class PrivilegeEscalationDetector : public DetectorBase {
private:
    std::set<std::string> privileged_syscalls;
    std::set<gimple*> privileged_call_sites;
    void initialize_syscalls();
    bool is_privileged_syscall(const std::string& name);
    void check_syscall(gimple *stmt);
    void check_permission_check(gimple *stmt);
    bool has_permission_check(tree var, basic_block bb);
    bool is_privileged_var(tree var);

public:
    void initialize() override;
    void analyze_function(tree fndecl) override;
    void finalize() override;
    std::string get_name() const override { return "PrivilegeEscalation"; }
    std::string get_type() const override { return "PrivilegeEscalation"; }
    std::string get_description() const override {
        return "Detects privilege escalation vulnerabilities including missing permission checks";
    }
};

class TOCTOUDetector : public DetectorBase {
private:
    std::set<std::string> race_prone_functions;
    void initialize_functions();
    bool is_race_prone_function(const std::string& name);
    void check_toctou_pattern(gimple *stmt);
    bool is_file_operation(gimple *stmt);

public:
    void initialize() override;
    void analyze_function(tree fndecl) override;
    void finalize() override;
    std::string get_name() const override { return "TOCTOU"; }
    std::string get_type() const override { return "TOCTOU"; }
    std::string get_description() const override {
        return "Detects Time-of-Check-Time-of-Use (TOCTOU) vulnerabilities";
    }
};

#endif // PRIVILEGE_DETECTOR_H