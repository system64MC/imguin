# This file is just for package development purpose.
#
.PHONY: example clean install updater gen

all: example

install:
	nimble install

example:
	make -C examples

clean:
	make -C examples clean

EXT_LIB_DIR = ../libs
TARGET_DIR = src/imguin/private

updater:
	$(MAKE) -C $(TARGET_DIR)/$@

gen: copylibs updater


copylibs: imgui implot imnodes imguizmo
	cp -f $(EXT_LIB_DIR)/cimgui/{LICENSE,*.cpp,*.h}             		 $(TARGET_DIR)/cimgui/
	cp -f $(EXT_LIB_DIR)/cimgui/imgui/{LICENSE.txt,*.cpp,*.h}   		 $(TARGET_DIR)/cimgui/imgui/
	cp -f $(EXT_LIB_DIR)/cimgui/imgui/backends/{*.cpp,*.h}      		 $(TARGET_DIR)/cimgui/imgui/backends/
	cp -f $(EXT_LIB_DIR)/cimplot/{LICENSE,*.cpp,*.h}            		 $(TARGET_DIR)/cimplot/
	cp -f $(EXT_LIB_DIR)/cimplot/implot/{LICENSE,*.cpp,*.h}     		 $(TARGET_DIR)/cimplot/implot/
	cp -f $(EXT_LIB_DIR)/cimnodes/{README.md,*.cpp,*.h}         		 $(TARGET_DIR)/cimnodes/
	cp -f $(EXT_LIB_DIR)/cimnodes/imnodes/{LICENSE.md,*.cpp,*.h}     $(TARGET_DIR)/cimnodes/imnodes/
	cp -f $(EXT_LIB_DIR)/cimguizmo/{LICENSE,*.cpp,*.h}             	 $(TARGET_DIR)/cimguizmo/
	cp -f $(EXT_LIB_DIR)/cimguizmo/ImGuizmo/{LICENSE,*.cpp,*.h}      $(TARGET_DIR)/cimguizmo/ImGuizmo/


.PHONY: cimgui cimplot cimnodes cimguizmo

imgui:
	-mkdir -p $(TARGET_DIR)/cimgui/$@
	-mkdir -p $(TARGET_DIR)/cimgui/$@/backends

implot:
	-mkdir -p $(TARGET_DIR)/cimplot/$@

imnodes:
	-mkdir -p $(TARGET_DIR)/cimnodes/$@

imguizmo:
	-mkdir -p $(TARGET_DIR)/cimguizmo/$@

libs:
	-mkdir -p ../$@


clonelibs: cimgui cimplot cimnodes cimguizmo

cimgui:
	git clone --recurse-submodules https://github.com/cimgui/cimgui    ../libs/cimgui
cimplot:
	git clone --recurse-submodules https://github.com/cimgui/cimplot   ../libs/cimplot
cimnodes:
	git clone --recurse-submodules https://github.com/cimgui/cimnodes  ../libs/cimnodes
cimguizmo:
	git clone --recurse-submodules https://github.com/cimgui/cimguizmo ../libs/cimguizmo
