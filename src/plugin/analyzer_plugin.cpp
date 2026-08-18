#include <gcc-plugin.h>
#include <plugin-version.h>
#include <tree.h>
#include <tree-pass.h>
#include <context.h>
#include <function.h>
#include <gimple.h>
#include <gimple-iterator.h>
#include <gimple-pretty-print.h>
#include <cgraph.h>
#include <print-tree.h>
#include <iostream>
#include <string>
#include <vector>
#include <stdio.h>
#include <map>
#include <set>
#include <fstream>
#include <sstream>
#include <iomanip>

#include "detectors/detector_manager.h"
#include "detectors/memory_detector.h"
#include "detectors/leak_detector.h"
#include "detectors/privilege_detector.h"

// License check
int plugin_is_GPL_compatible;

// Global detector manager
DetectorManager *detector_manager = nullptr;

// Cache for function lock effects: +1 (locks), -1 (unlocks), 0 (neutral)
std::map<std::string, int> lock_effect_cache;
std::set<std::string> visiting; // For recursion detection

// Data structure for JSON export
struct FunctionAnalysis {
    std::string name;
    std::set<std::string> callees;
    std::set<std::string> global_reads;
    std::set<std::string> global_writes;
};

// Forward declaration
int get_lock_effect(tree fndecl);

// Helper to capture gimple print
std::string gimple_to_string(gimple *stmt) {
    char *bp;
    size_t size;
    FILE *stream = open_memstream(&bp, &size);
    if (!stream) return "Error capturing stmt";
    print_gimple_stmt(stream, stmt, 0, TDF_NONE);
    fflush(stream);
    std::string res(bp);
    while (!res.empty() && (res.back() == '\n' || res.back() == '\r')) res.pop_back();
    fclose(stream);
    free(bp);
    return res;
}

bool is_lock_function(const char* name) {
    if (!name) return false;
    std::string s(name);
    return (s.find("spin_lock") != std::string::npos ||
            s.find("mutex_lock") != std::string::npos ||
            s.find("read_lock") != std::string::npos ||
            s.find("write_lock") != std::string::npos ||
            s.find("down") != std::string::npos);
}

bool is_unlock_function(const char* name) {
    if (!name) return false;
    std::string s(name);
    return (s.find("spin_unlock") != std::string::npos ||
            s.find("mutex_unlock") != std::string::npos ||
            s.find("read_unlock") != std::string::npos ||
            s.find("write_unlock") != std::string::npos ||
            s.find("up") != std::string::npos);
}

int compute_lock_effect(tree fndecl) {
    const char* name = IDENTIFIER_POINTER(DECL_NAME(fndecl));
    
    if (is_lock_function(name)) return 1;
    if (is_unlock_function(name)) return -1;
    
    struct function *fn = DECL_STRUCT_FUNCTION(fndecl);
    if (!fn) return 0;
    
    int net_effect = 0;
    basic_block bb;
    gimple_stmt_iterator gsi;
    
    FOR_EACH_BB_FN(bb, fn) {
        for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
            gimple *stmt = gsi_stmt(gsi);
            if (is_gimple_call(stmt)) {
                tree callee = gimple_call_fndecl(stmt);
                if (callee) {
                    net_effect += get_lock_effect(callee);
                }
            }
        }
    }
    return net_effect;
}

int get_lock_effect(tree fndecl) {
    if (!fndecl) return 0;
    const char* name = IDENTIFIER_POINTER(DECL_NAME(fndecl));
    std::string s_name(name);
    
    if (lock_effect_cache.count(s_name)) return lock_effect_cache[s_name];
    
    if (visiting.count(s_name)) return 0;
    
    visiting.insert(s_name);
    int effect = compute_lock_effect(fndecl);
    visiting.erase(s_name);
    
    lock_effect_cache[s_name] = effect;
    return effect;
}

void analyze_node(cgraph_node *node, FILE *ast_out, FunctionAnalysis &fa) {
    tree fndecl = node->decl;
    if (!fndecl || !DECL_STRUCT_FUNCTION(fndecl)) return;

    push_cfun(DECL_STRUCT_FUNCTION(fndecl));
    calculate_dominance_info(CDI_DOMINATORS);

    const char *func_name = IDENTIFIER_POINTER(DECL_NAME(fndecl));
    fa.name = func_name;
    fprintf(ast_out, "\n\033[1;34mFunction: %s\033[0m\n", func_name);

    // 调用检测器分析函数
    if (detector_manager) {
        detector_manager->analyze_function(fndecl);
    }

    std::set<std::string> lockset;
    
    basic_block bb;
    gimple_stmt_iterator gsi;

    FOR_EACH_BB_FN(bb, cfun) {
        if (bb->index < 2) continue; 
        fprintf(ast_out, "  \033[1;33m├── Basic Block %d\033[0m\n", bb->index);

        for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
            gimple *stmt = gsi_stmt(gsi);
            std::string stmt_str = gimple_to_string(stmt);
            fprintf(ast_out, "  │   ├── %s\n", stmt_str.c_str());

            if (is_gimple_call(stmt)) {
                tree fn = gimple_call_fndecl(stmt);
                if (fn) {
                    const char* name = IDENTIFIER_POINTER(DECL_NAME(fn));
                    fa.callees.insert(name);
                    
                    std::string lock_name = "unknown_lock";
                    if (gimple_call_num_args(stmt) > 0) {
                        tree arg = gimple_call_arg(stmt, 0);
                        if (TREE_CODE(arg) == ADDR_EXPR) arg = TREE_OPERAND(arg, 0);
                        if (DECL_P(arg) && DECL_NAME(arg)) 
                            lock_name = IDENTIFIER_POINTER(DECL_NAME(arg));
                    }

                    int effect = get_lock_effect(fn);
                    
                    if (effect > 0) {
                        lockset.insert(lock_name);
                        fprintf(ast_out, "  │   │   \033[1;36m└── [LOCK] Acquired '%s' via '%s' (Set Size: %lu)\033[0m\n", lock_name.c_str(), name, lockset.size());
                    } else if (effect < 0) {
                        lockset.erase(lock_name);
                        fprintf(ast_out, "  │   │   \033[1;36m└── [UNLOCK] Released '%s' via '%s' (Set Size: %lu)\033[0m\n", lock_name.c_str(), name, lockset.size());
                    }
                }
            }

            if (is_gimple_assign(stmt)) {
                tree lhs = gimple_assign_lhs(stmt);
                tree rhs1 = gimple_assign_rhs1(stmt);
                
                if (TREE_CODE(lhs) == VAR_DECL && is_global_var(lhs)) {
                     const char* var_name = IDENTIFIER_POINTER(DECL_NAME(lhs));
                     fa.global_writes.insert(var_name);
                     fprintf(ast_out, "  │   │   \033[1;31m└── [WRITE] Global '%s'\033[0m\n", var_name);
                     fprintf(stderr, "[WRITE] Global '%s' in function '%s'\n", var_name, func_name);

                     if (lockset.empty()) {
                         fprintf(ast_out, "  │   │   \033[1;41;37m└── [RACE_WARNING] Unprotected Write to '%s'\033[0m\n", var_name);
                         fprintf(stderr, "[RACE_WARNING] Unprotected Write to '%s' in '%s'\n", var_name, func_name);
                     }
                }

                if (TREE_CODE(rhs1) == VAR_DECL && is_global_var(rhs1)) {
                     const char* var_name = IDENTIFIER_POINTER(DECL_NAME(rhs1));
                     fa.global_reads.insert(var_name);
                     fprintf(ast_out, "  │   │   \033[1;32m└── [READ] Global '%s'\033[0m\n", var_name);
                     fprintf(stderr, "[READ] Global '%s' in function '%s'\n", var_name, func_name);

                     if (lockset.empty()) {
                         fprintf(ast_out, "  │   │   \033[1;41;37m└── [RACE_WARNING] Unprotected Read from '%s'\033[0m\n", var_name);
                         fprintf(stderr, "[RACE_WARNING] Unprotected Read from '%s' in '%s'\n", var_name, func_name);
                     }
                }
            }
        }
    }
    pop_cfun();
}

const pass_data analyzer_pass_data = {
    SIMPLE_IPA_PASS,
    "analyzer_ipa_pass",
    OPTGROUP_NONE,
    TV_NONE,
    PROP_cfg,
    0,
    0,
    0,
    0,
};

class analyzer_ipa_pass : public simple_ipa_opt_pass {
public:
    analyzer_ipa_pass(gcc::context *ctxt) 
        : simple_ipa_opt_pass(analyzer_pass_data, ctxt) {}
        
    unsigned int execute(function *fun) override {
        FILE *ast_out = stdout;
        const char *log_path = getenv("AST_LOG_FILE");
        bool close_ast_file = false;
        if (log_path) {
            ast_out = fopen(log_path, "a");
            if (ast_out) close_ast_file = true;
        }

        const char *json_dir = getenv("ANALYSIS_JSON_DIR");
        std::vector<FunctionAnalysis> results;

        cgraph_node *node;
        FOR_EACH_DEFINED_FUNCTION(node) {
            FunctionAnalysis fa;
            analyze_node(node, ast_out, fa);
            results.push_back(fa);
        }

        if (close_ast_file) fclose(ast_out);

        if (json_dir && !results.empty()) {
            std::stringstream ss;
            ss << json_dir << "/data_" << getpid() << ".json";
            std::ofstream json_out(ss.str());
            if (json_out.is_open()) {
                json_out << "[\n";
                for (size_t i = 0; i < results.size(); ++i) {
                    const auto& fa = results[i];
                    json_out << "  {\n";
                    json_out << "    \"name\": \"" << fa.name << "\",\n";
                    
                    json_out << "    \"callees\": [";
                    size_t j = 0;
                    for (const auto& c : fa.callees) {
                        json_out << "\"" << c << "\"" << (j++ < fa.callees.size() - 1 ? ", " : "");
                    }
                    json_out << "],\n";

                    json_out << "    \"global_reads\": [";
                    j = 0;
                    for (const auto& r : fa.global_reads) {
                        json_out << "\"" << r << "\"" << (j++ < fa.global_reads.size() - 1 ? ", " : "");
                    }
                    json_out << "],\n";

                    json_out << "    \"global_writes\": [";
                    j = 0;
                    for (const auto& w : fa.global_writes) {
                        json_out << "\"" << w << "\"" << (j++ < fa.global_writes.size() - 1 ? ", " : "");
                    }
                    json_out << "]\n";

                    json_out << "  }" << (i < results.size() - 1 ? "," : "") << "\n";
                }
                json_out << "]\n";
                json_out.close();
            }
        }

        // 调用检测器的finalize方法并导出结果
        if (detector_manager) {
            detector_manager->finalize_all();
            detector_manager->print_summary();
            
            if (json_dir) {
                std::stringstream ss;
                ss << json_dir << "/detections_" << getpid() << ".json";
                detector_manager->export_results_json(ss.str());
            }
        }

        return 0;
    }
    
    analyzer_ipa_pass* clone() override { return new analyzer_ipa_pass(m_ctxt); }
};

int plugin_init(struct plugin_name_args *plugin_info,
                struct plugin_gcc_version *version) {
    
    if (!plugin_default_version_check(version, &gcc_version)) {
        fprintf(stderr, "Incompatible GCC version\n");
        return 1;
    }

    detector_manager = new DetectorManager();
    
    detector_manager->register_detector(std::make_unique<BufferOverflowDetector>());
    detector_manager->register_detector(std::make_unique<NullPointerDetector>());
    detector_manager->register_detector(std::make_unique<UseAfterFreeDetector>());
    detector_manager->register_detector(std::make_unique<InfoLeakDetector>());
    detector_manager->register_detector(std::make_unique<PrivilegeEscalationDetector>());
    detector_manager->register_detector(std::make_unique<TOCTOUDetector>());

    detector_manager->initialize_all();

    struct register_pass_info pass_info;
    pass_info.pass = new analyzer_ipa_pass(g);
    pass_info.reference_pass_name = "simdclone";
    pass_info.ref_pass_instance_number = 1;
    pass_info.pos_op = PASS_POS_INSERT_AFTER;

    register_callback(plugin_info->base_name, PLUGIN_PASS_MANAGER_SETUP, NULL, &pass_info);
    
    fprintf(stderr, "Analyzer Plugin Loaded! (IPA Mode with 6 detectors)\n");
    return 0;
}