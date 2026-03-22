#ifndef DETECTOR_MANAGER_H
#define DETECTOR_MANAGER_H

#include "detector_base.h"
#include <memory>
#include <vector>
#include <map>
#include <fstream>
#include <numeric>

class DetectorManager {
private:
    std::vector<std::unique_ptr<DetectorBase>> detectors;
    std::map<std::string, std::vector<DetectionResult>> all_results;

public:
    DetectorManager() = default;
    ~DetectorManager() = default;

    void register_detector(std::unique_ptr<DetectorBase> detector) {
        detectors.push_back(std::move(detector));
    }

    void initialize_all() {
        for (auto& detector : detectors) {
            detector->initialize();
        }
    }

    void analyze_function(tree fndecl) {
        for (auto& detector : detectors) {
            detector->analyze_function(fndecl);
        }
    }

    void finalize_all() {
        for (auto& detector : detectors) {
            detector->finalize();
            std::string type = detector->get_type();
            const std::vector<DetectionResult>& detector_results = detector->get_results();
            all_results[type].insert(all_results[type].end(), detector_results.begin(), detector_results.end());
        }
    }

    void export_results_json(const std::string& json_file) {
        std::ofstream json_out(json_file);
        if (!json_out.is_open()) {
            fprintf(stderr, "Failed to open JSON file: %s\n", json_file.c_str());
            return;
        }

        json_out << "[\n";

        bool first = true;
        for (auto& pair : all_results) {
            const std::vector<DetectionResult>& results = pair.second;
            for (auto& result : results) {
                if (!first) {
                    json_out << ",\n";
                }
                first = false;

                json_out << "  {\n";
                json_out << "    \"type\": \"" << result.type << "\",\n";
                json_out << "    \"severity\": \"" << result.severity << "\",\n";
                json_out << "    \"message\": \"" << result.message << "\",\n";
                json_out << "    \"file\": \"" << result.file << "\",\n";
                json_out << "    \"line\": " << result.line << ",\n";
                json_out << "    \"column\": " << result.column << ",\n";
                json_out << "    \"suggestion\": \"" << result.suggestion << "\"\n";
                json_out << "  }";
            }
        }

        json_out << "\n]\n";
        json_out.close();
    }

    void print_summary() {
        fprintf(stdout, "\n=== Detection Summary ===\n");
        size_t total = 0;
        for (auto& pair : all_results) {
            const std::string& type = pair.first;
            const std::vector<DetectionResult>& results = pair.second;
            size_t count = results.size();
            total += count;
            fprintf(stdout, "%s: %zu findings\n", type.c_str(), count);
        }
        fprintf(stdout, "Total: %zu findings\n", total);
    }

    const std::map<std::string, std::vector<DetectionResult>>& get_all_results() const {
        return all_results;
    }
};

#endif // DETECTOR_MANAGER_H