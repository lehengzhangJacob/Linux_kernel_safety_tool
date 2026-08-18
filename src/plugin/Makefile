# Build analyzer_plugin.so for a specific GCC (host or cross-compiler binary).
#
# Important: the cross compiler (e.g. aarch64-linux-gnu-gcc) is still a *host*
# process. The plugin .so must be a host ELF built with host g++, but compiled
# against that GCC's plugin headers / version.
#
# Usage:
#   make
#   make GCC=aarch64-linux-gnu-gcc HOST_CXX=g++
#
# Output: build/<triplet>/analyzer_plugin.so

GCC ?= gcc
HOST_CXX ?= g++

PLUGIN_DIR := $(shell $(GCC) -print-file-name=plugin)
TRIPLET := $(shell $(GCC) -dumpmachine)
GCC_VER := $(shell $(GCC) -dumpversion)
# Include GCC version so apt GCC13 and vendor GCC8 (same triplet) do not clobber each other
BUILD_DIR := build/$(TRIPLET)-$(GCC_VER)

CXXFLAGS := -I$(PLUGIN_DIR)/include -fPIC -fno-rtti -O2 -Wall -std=c++17

DETECTOR_SOURCES := \
	detectors/memory_detector.cpp \
	detectors/leak_detector.cpp \
	detectors/privilege_detector.cpp

DETECTOR_OBJECTS := $(addprefix $(BUILD_DIR)/,$(DETECTOR_SOURCES:.cpp=.o))
PLUGIN_OBJECTS := $(BUILD_DIR)/analyzer_plugin.o
PLUGIN_SO := $(BUILD_DIR)/analyzer_plugin.so

.PHONY: all clean print-paths

all: $(PLUGIN_SO)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)/detectors

$(BUILD_DIR)/detectors/%.o: detectors/%.cpp detectors/%.h | $(BUILD_DIR)
	$(HOST_CXX) $(CXXFLAGS) -c -o $@ $<

$(BUILD_DIR)/analyzer_plugin.o: analyzer_plugin.cpp | $(BUILD_DIR)
	$(HOST_CXX) $(CXXFLAGS) -c -o $@ $<

$(PLUGIN_SO): $(PLUGIN_OBJECTS) $(DETECTOR_OBJECTS)
	$(HOST_CXX) $(CXXFLAGS) -shared -o $@ $(PLUGIN_OBJECTS) $(DETECTOR_OBJECTS)
	@echo "[+] Built $@ (load-with GCC=$(GCC) headers=$(PLUGIN_DIR) HOST_CXX=$(HOST_CXX))"

print-paths:
	@echo "GCC=$(GCC)"
	@echo "HOST_CXX=$(HOST_CXX)"
	@echo "TRIPLET=$(TRIPLET)"
	@echo "PLUGIN_DIR=$(PLUGIN_DIR)"
	@echo "PLUGIN_SO=$(PLUGIN_SO)"

clean:
	rm -rf build
	rm -f analyzer_plugin.so detectors/*.o analyzer_plugin.o
