GCC := gcc
CXX := g++
PLUGIN_DIR := $(shell $(GCC) -print-file-name=plugin)
CXXFLAGS := -I$(PLUGIN_DIR)/include -fPIC -fno-rtti -O2 -shared -Wall

all: analyzer_plugin.so

analyzer_plugin.so: analyzer_plugin.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

clean:
	rm -f analyzer_plugin.so
