PROJECT := jelly
BUILD_DIR := build/

# Targets
.PHONY: all

all: clean copy build_release

run: all
	@echo "Running..."
	$(BUILD_DIR)${PROJECT}.exe

debug: clean copy build_debug
	@echo "Running (debug)..."
	$(BUILD_DIR)${PROJECT}.exe

build_debug: all
	@echo "Building (debug)..."
	odin build . -debug -out:$(BUILD_DIR)${PROJECT}.exe

build_release:
	@echo "Building (release)..."
	odin build . -out:$(BUILD_DIR)${PROJECT}.exe

copy:
	@echo "Copying files..."
	@if [ -d "shaders/" ]; then cp -r shaders/ $(BUILD_DIR); fi

clean:
	@echo "Cleaning..."
	rm -rf $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)