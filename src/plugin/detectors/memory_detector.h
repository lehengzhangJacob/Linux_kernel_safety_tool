#ifndef MEMORY_DETECTOR_H
#define MEMORY_DETECTOR_H

#include "detector_base.h"
#include <set>
#include <map>

class BufferOverflowDetector : public DetectorBase {
private:
    void check_array_access(gimple *stmt);
    void check_string_operation(gimple *stmt);
    bool is_potential_overflow(tree expr, gimple *stmt);
    bool is_array_access(tree expr);
    bool is_string_operation(gimple *stmt);
    bool is_memory_copy_operation(gimple *stmt);

public:
    void initialize() override {
        fprintf(stderr, "[BufferOverflowDetector] Initialized\n");
    }

    void analyze_function(tree fndecl) override;
    void finalize() override;
    std::string get_name() const override { return "BufferOverflow"; }
    std::string get_type() const override { return "MemorySafety"; }
    std::string get_description() const override {
        return "Detects buffer overflow vulnerabilities including array bounds violations and string overflows";
    }
};

class NullPointerDetector : public DetectorBase {
private:
    std::set<tree> checked_pointers;
    void check_pointer_dereference(gimple *stmt);
    bool is_potential_null(tree ptr);
    bool has_null_check(tree ptr, basic_block bb);

public:
    void initialize() override {
        checked_pointers.clear();
        fprintf(stderr, "[NullPointerDetector] Initialized\n");
    }

    void analyze_function(tree fndecl) override;
    void finalize() override;
    std::string get_name() const override { return "NullPointer"; }
    std::string get_type() const override { return "MemorySafety"; }
    std::string get_description() const override {
        return "Detects null pointer dereference vulnerabilities";
    }
};

class UseAfterFreeDetector : public DetectorBase {
private:
    std::set<tree> freed_pointers;
    void check_pointer_use(gimple *stmt);
    bool is_free_call(gimple *stmt);
    tree get_freed_pointer(gimple *stmt);

public:
    void initialize() override {
        freed_pointers.clear();
        fprintf(stderr, "[UseAfterFreeDetector] Initialized\n");
    }

    void analyze_function(tree fndecl) override;
    void finalize() override;
    std::string get_name() const override { return "UseAfterFree"; }
    std::string get_type() const override { return "MemorySafety"; }
    std::string get_description() const override {
        return "Detects use-after-free vulnerabilities";
    }
};

#endif // MEMORY_DETECTOR_H