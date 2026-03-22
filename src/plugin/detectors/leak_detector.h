#ifndef LEAK_DETECTOR_H
#define LEAK_DETECTOR_H

#include "detector_base.h"
#include <set>
#include <map>
#include <string>

class InfoLeakDetector : public DetectorBase {
private:
    std::set<std::string> sensitive_patterns;
    std::map<tree, std::string> sensitive_vars;

    void initialize_patterns();
    bool is_sensitive_data(const std::string& var_name);
    bool is_sensitive_string(tree expr);
    void track_sensitive_data_flow(tree var, basic_block bb);
    bool is_log_function(gimple *stmt);
    bool is_error_output(gimple *stmt);
    bool is_network_output(gimple *stmt);
    bool is_file_output(gimple *stmt);
    void check_log_output(gimple *stmt);

public:
    void initialize() override;
    void analyze_function(tree fndecl) override;
    void finalize() override;
    std::string get_name() const override { return "InfoLeak"; }
    std::string get_type() const override { return "InfoLeak"; }
    std::string get_description() const override {
        return "Detects information leakage vulnerabilities including sensitive data exposure";
    }
};

#endif // LEAK_DETECTOR_H