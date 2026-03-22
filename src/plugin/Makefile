GCC := gcc
CXX := g++
PLUGIN_DIR := $(shell $(GCC) -print-file-name=plugin)
CXXFLAGS := -I$(PLUGIN_DIR)/include -fPIC -fno-rtti -O2 -shared -Wall -std=c++17

# Detector source files
DETECTOR_SOURCES := \
	detectors/memory_detector.cpp \
	detectors/leak_detector.cpp \
	detectors/privilege_detector.cpp

DETECTOR_OBJECTS := $(DETECTOR_SOURCES:.cpp=.o)

# Main plugin source
PLUGIN_SOURCES := analyzer_plugin.cpp
PLUGIN_OBJECTS := $(PLUGIN_SOURCES:.cpp=.o)

all: analyzer_plugin.so

# Build detector objects
detectors/%.o: detectors/%.cpp detectors/%.h
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# Build main plugin
analyzer_plugin.so: $(PLUGIN_OBJECTS) $(DETECTOR_OBJECTS)
	$(CXX) $(CXXFLAGS) -o $@ $(PLUGIN_OBJECTS) $(DETECTOR_OBJECTS)

clean:
	rm -f analyzer_plugin.so $(PLUGIN_OBJECTS) $(DETECTOR_OBJECTS)

.PHONY: all clean