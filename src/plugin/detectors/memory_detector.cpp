#include "memory_detector.h"
#include <gimple.h>
#include <gimple-iterator.h>
#include <tree.h>
#include <string.h>

// -----------------------------------------------------------------------------
// BufferOverflowDetector Implementation
// -----------------------------------------------------------------------------

void BufferOverflowDetector::analyze_function(tree fndecl) {
    set_current_function(fndecl);

    if (!fndecl || !DECL_STRUCT_FUNCTION(fndecl)) return;

    push_cfun(DECL_STRUCT_FUNCTION(fndecl));

    basic_block bb;
    gimple_stmt_iterator gsi;

    FOR_EACH_BB_FN(bb, cfun) {
        for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
            gimple *stmt = gsi_stmt(gsi);

            check_array_access(stmt);
            check_string_operation(stmt);
        }
    }

    pop_cfun();
}

void BufferOverflowDetector::finalize() {
    fprintf(stdout, "[BufferOverflowDetector] Found %zu buffer overflow issues\n", results.size());
}

bool BufferOverflowDetector::is_array_access(tree expr) {
    if (!expr) return false;

    tree_code code = TREE_CODE(expr);
    return code == ARRAY_REF || code == COMPONENT_REF;
}

bool BufferOverflowDetector::is_string_operation(gimple *stmt) {
    if (!stmt || !is_gimple_call(stmt)) return false;

    tree fn = gimple_call_fndecl(stmt);
    if (!fn) return false;

    const char* name = IDENTIFIER_POINTER(DECL_NAME(fn));
    if (!name) return false;

    std::string fname(name);
    return fname.find("strcpy") != std::string::npos ||
           fname.find("strcat") != std::string::npos ||
           fname.find("sprintf") != std::string::npos ||
           fname.find("gets") != std::string::npos ||
           fname.find("scanf") != std::string::npos;
}

bool BufferOverflowDetector::is_memory_copy_operation(gimple *stmt) {
    if (!stmt || !is_gimple_call(stmt)) return false;

    tree fn = gimple_call_fndecl(stmt);
    if (!fn) return false;

    const char* name = IDENTIFIER_POINTER(DECL_NAME(fn));
    if (!name) return false;

    std::string fname(name);
    return fname.find("memcpy") != std::string::npos ||
           fname.find("memmove") != std::string::npos ||
           fname.find("memset") != std::string::npos ||
           fname.find("bcopy") != std::string::npos;
}

bool BufferOverflowDetector::is_potential_overflow(tree expr, gimple *stmt) {
    if (!is_array_access(expr)) return false;

    tree array = TREE_OPERAND(expr, 0);
    tree index = TREE_OPERAND(expr, 1);

    if (!array || !index) return false;

    tree array_type = TREE_TYPE(array);
    if (!array_type || TREE_CODE(array_type) != ARRAY_TYPE) return false;

    tree domain = TYPE_DOMAIN(array_type);
    if (!domain) return false;

    tree max_index = TYPE_MAX_VALUE(domain);
    if (!max_index || TREE_CODE(max_index) != INTEGER_CST) return false;

    if (TREE_CODE(index) == INTEGER_CST) {
        HOST_WIDE_INT idx_val = TREE_INT_CST_LOW(index);
        HOST_WIDE_INT max_val = TREE_INT_CST_LOW(max_index);

        if (idx_val < 0 || idx_val > max_val) {
            return true;
        }
    } else {
        // 对于非常量索引，检查是否有边界检查
        basic_block bb = gimple_bb(stmt);
        if (bb) {
            gimple_stmt_iterator gsi;
            for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
                gimple *cond_stmt = gsi_stmt(gsi);
                if (gimple_code(cond_stmt) == GIMPLE_COND) {
                    tree_code cond_code = gimple_cond_code(cond_stmt);
                    tree op0 = gimple_cond_lhs(cond_stmt);
                    tree op1 = gimple_cond_rhs(cond_stmt);

                    if ((cond_code == LE_EXPR || cond_code == LT_EXPR) &&
                        ((op0 == index && TREE_CODE(op1) == INTEGER_CST) ||
                         (op1 == index && TREE_CODE(op0) == INTEGER_CST))) {
                        // 有边界检查，不认为是潜在溢出
                        return false;
                    }
                }
            }
        }
        // 非常量索引且无边界检查，认为是潜在溢出
        return true;
    }

    return false;
}

void BufferOverflowDetector::check_array_access(gimple *stmt) {
    if (!is_gimple_assign(stmt) && !is_gimple_call(stmt)) return;

    tree lhs = is_gimple_assign(stmt) ? gimple_assign_lhs(stmt) : NULL_TREE;
    tree rhs1 = is_gimple_assign(stmt) ? gimple_assign_rhs1(stmt) : NULL_TREE;

    if (lhs && is_array_access(lhs) && is_potential_overflow(lhs, stmt)) {
        expanded_location loc;
        loc = expand_location(gimple_location(stmt));
        add_result("BufferOverflow", "Critical",
                   "Potential buffer overflow in array write",
                   loc.line, loc.column,
                   "Add bounds checking before array access");
    }

    if (rhs1 && is_array_access(rhs1) && is_potential_overflow(rhs1, stmt)) {
        expanded_location loc;
        loc = expand_location(gimple_location(stmt));
        add_result("BufferOverflow", "Critical",
                   "Potential buffer overflow in array read",
                   loc.line, loc.column,
                   "Add bounds checking before array access");
    }
}

void BufferOverflowDetector::check_string_operation(gimple *stmt) {
    if (!is_string_operation(stmt) && !is_memory_copy_operation(stmt)) return;

    expanded_location loc;
    loc = expand_location(gimple_location(stmt));

    if (is_string_operation(stmt)) {
        add_result("BufferOverflow", "Critical",
                   "Unsafe string operation may cause buffer overflow",
                   loc.line, loc.column,
                   "Use safe string functions (strncpy, strncat, snprintf)");
    } else if (is_memory_copy_operation(stmt)) {
        add_result("BufferOverflow", "Critical",
                   "Unsafe memory copy operation may cause buffer overflow",
                   loc.line, loc.column,
                   "Add bounds checking before memory copy operation");
    }
}

// -----------------------------------------------------------------------------
// NullPointerDetector Implementation
// -----------------------------------------------------------------------------

void NullPointerDetector::analyze_function(tree fndecl) {
    set_current_function(fndecl);

    if (!fndecl || !DECL_STRUCT_FUNCTION(fndecl)) return;

    checked_pointers.clear();
    push_cfun(DECL_STRUCT_FUNCTION(fndecl));

    basic_block bb;
    gimple_stmt_iterator gsi;

    FOR_EACH_BB_FN(bb, cfun) {
        for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
            gimple *stmt = gsi_stmt(gsi);
            check_pointer_dereference(stmt);
        }
    }

    pop_cfun();
}

void NullPointerDetector::finalize() {
    fprintf(stdout, "[NullPointerDetector] Found %zu null pointer issues\n", results.size());
}

bool NullPointerDetector::is_potential_null(tree ptr) {
    if (!ptr) return false;

    tree_code code = TREE_CODE(ptr);
    if (code != SSA_NAME && code != VAR_DECL && code != PARM_DECL) {
        return false;
    }

    return checked_pointers.find(ptr) == checked_pointers.end();
}

bool NullPointerDetector::has_null_check(tree ptr, basic_block bb) {
    if (!ptr || !bb) return false;

    gimple_stmt_iterator gsi;
    for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
        gimple *stmt = gsi_stmt(gsi);

        if (gimple_code(stmt) == GIMPLE_COND) {
            tree_code cond_code = gimple_cond_code(stmt);
            tree op0 = gimple_cond_lhs(stmt);
            tree op1 = gimple_cond_rhs(stmt);

            if (cond_code == EQ_EXPR || cond_code == NE_EXPR) {
                if ((op0 == ptr && integer_zerop(op1)) ||
                    (op1 == ptr && integer_zerop(op0))) {
                    return true;
                }
            }
        }
    }

    return false;
}

void NullPointerDetector::check_pointer_dereference(gimple *stmt) {
    if (!is_gimple_assign(stmt) && !is_gimple_call(stmt)) return;

    tree lhs = is_gimple_assign(stmt) ? gimple_assign_lhs(stmt) : NULL_TREE;
    tree rhs1 = is_gimple_assign(stmt) ? gimple_assign_rhs1(stmt) : NULL_TREE;

    tree ptr = NULL_TREE;

    if (lhs && TREE_CODE(lhs) == MEM_REF) {
        ptr = TREE_OPERAND(lhs, 0);
    }

    if (rhs1 && TREE_CODE(rhs1) == MEM_REF) {
        ptr = TREE_OPERAND(rhs1, 0);
    }

    if (is_gimple_call(stmt)) {
        for (unsigned i = 0; i < gimple_call_num_args(stmt); i++) {
            tree arg = gimple_call_arg(stmt, i);
            if (arg && TREE_CODE(arg) == MEM_REF) {
                ptr = TREE_OPERAND(arg, 0);
                break;
            }
        }
    }

    if (ptr && is_potential_null(ptr)) {
        basic_block bb = gimple_bb(stmt);
        if (!has_null_check(ptr, bb)) {
            expanded_location loc;
            loc = expand_location(gimple_location(stmt));
            add_result("NullPointer", "High",
                       "Potential null pointer dereference",
                       loc.line, loc.column,
                       "Add null check before dereferencing pointer");
        }
    }
}

// -----------------------------------------------------------------------------
// UseAfterFreeDetector Implementation
// -----------------------------------------------------------------------------

void UseAfterFreeDetector::analyze_function(tree fndecl) {
    set_current_function(fndecl);

    if (!fndecl || !DECL_STRUCT_FUNCTION(fndecl)) return;

    freed_pointers.clear();
    push_cfun(DECL_STRUCT_FUNCTION(fndecl));

    basic_block bb;
    gimple_stmt_iterator gsi;

    FOR_EACH_BB_FN(bb, cfun) {
        for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
            gimple *stmt = gsi_stmt(gsi);
            check_pointer_use(stmt);
        }
    }

    pop_cfun();
}

void UseAfterFreeDetector::finalize() {
    fprintf(stdout, "[UseAfterFreeDetector] Found %zu use-after-free issues\n", results.size());
}

bool UseAfterFreeDetector::is_free_call(gimple *stmt) {
    if (!stmt || !is_gimple_call(stmt)) return false;

    tree fn = gimple_call_fndecl(stmt);
    if (!fn) return false;

    const char* name = IDENTIFIER_POINTER(DECL_NAME(fn));
    if (!name) return false;

    std::string fname(name);
    return fname.find("kfree") != std::string::npos ||
           fname.find("vfree") != std::string::npos ||
           fname.find("free") != std::string::npos ||
           fname.find("kzfree") != std::string::npos ||
           fname.find("kvfree") != std::string::npos;
}

tree UseAfterFreeDetector::get_freed_pointer(gimple *stmt) {
    if (!is_free_call(stmt)) return NULL_TREE;

    if (gimple_call_num_args(stmt) > 0) {
        tree arg = gimple_call_arg(stmt, 0);
        return arg;
    }

    return NULL_TREE;
}

void UseAfterFreeDetector::check_pointer_use(gimple *stmt) {
    tree freed_ptr = get_freed_pointer(stmt);
    if (freed_ptr) {
        freed_pointers.insert(freed_ptr);
        return;
    }

    if (!is_gimple_assign(stmt) && !is_gimple_call(stmt)) return;

    tree lhs = is_gimple_assign(stmt) ? gimple_assign_lhs(stmt) : NULL_TREE;
    tree rhs1 = is_gimple_assign(stmt) ? gimple_assign_rhs1(stmt) : NULL_TREE;

    tree used_ptr = NULL_TREE;

    if (lhs && TREE_CODE(lhs) == MEM_REF) {
        used_ptr = TREE_OPERAND(lhs, 0);
    }

    if (rhs1 && TREE_CODE(rhs1) == MEM_REF) {
        used_ptr = TREE_OPERAND(rhs1, 0);
    }

    if (is_gimple_call(stmt)) {
        for (unsigned i = 0; i < gimple_call_num_args(stmt); i++) {
            tree arg = gimple_call_arg(stmt, i);
            if (arg && TREE_CODE(arg) == MEM_REF) {
                used_ptr = TREE_OPERAND(arg, 0);
                break;
            }
        }
    }

    if (used_ptr && freed_pointers.count(used_ptr) > 0) {
        expanded_location loc;
        loc = expand_location(gimple_location(stmt));
        add_result("UseAfterFree", "High",
                   "Use after free detected",
                   loc.line, loc.column,
                   "Set pointer to NULL after free");
    }
}