#ifndef DETECTOR_BASE_H
#define DETECTOR_BASE_H

#if __has_include(<gcc-plugin.h>)
#include <gcc-plugin.h>
#elif __has_include("/usr/lib/gcc/x86_64-linux-gnu/13/plugin/include/gcc-plugin.h")
#include "/usr/lib/gcc/x86_64-linux-gnu/13/plugin/include/gcc-plugin.h"
#else
#error "gcc-plugin.h not found. Please install GCC plugin headers or configure includePath."
#endif

#if __has_include(<tree.h>)
#include <tree.h>
#elif __has_include("/usr/lib/gcc/x86_64-linux-gnu/13/plugin/include/tree.h")
#include "/usr/lib/gcc/x86_64-linux-gnu/13/plugin/include/tree.h"
#else
#error "tree.h not found. Please install GCC plugin headers or configure includePath."
#endif
#include <string>
#include <vector>
#include <map>

struct DetectionResult {
    std::string type;
    std::string severity;
    std::string message;
    std::string file;
    int line;
    int column;
    std::string suggestion;

    DetectionResult(const std::string& t, const std::string& sev, const std::string& msg,
                 const std::string& f, int l, int c, const std::string& sugg)
        : type(t), severity(sev), message(msg), file(f), line(l), column(c), suggestion(sugg) {}
};

class DetectorBase {
public:
    virtual ~DetectorBase() = default;

    virtual void initialize() = 0;
    virtual void analyze_function(tree fndecl) = 0;
    virtual void finalize() = 0;
    virtual std::string get_name() const = 0;
    virtual std::string get_type() const = 0;
    virtual std::string get_description() const = 0;

    std::vector<DetectionResult>& get_results() { return results; }

protected:
    std::vector<DetectionResult> results;
    std::string current_function;
    std::string current_file;

    void add_result(const std::string& type, const std::string& severity,
                  const std::string& message, int line, int column,
                  const std::string& suggestion = "") {
        expanded_location loc;
        loc = expand_location(DECL_SOURCE_LOCATION(current_function_decl));
        std::string file = loc.file ? loc.file : "unknown";
        results.emplace_back(type, severity, message, file, line, column, suggestion);
    }

    void set_current_function(tree fndecl) {
        current_function_decl = fndecl;
        if (fndecl && DECL_NAME(fndecl)) {
            current_function = IDENTIFIER_POINTER(DECL_NAME(fndecl));
        }
        if (fndecl && DECL_SOURCE_LOCATION(fndecl)) {
            expanded_location loc;
            loc = expand_location(DECL_SOURCE_LOCATION(fndecl));
            current_file = loc.file ? loc.file : "unknown";
        }
    }

private:
    tree current_function_decl;
};

#endif // DETECTOR_BASE_H