BUILD_DIR := /tmp/forever-stars-build
SAVER     := $(BUILD_DIR)/Forever Stars.saver
INSTALL   := $(HOME)/Library/Screen Savers/Forever Stars.saver

.PHONY: build install clean

build:
	xcodebuild \
		-project "Forever Stars.xcodeproj" \
		-scheme "Forever Stars" \
		-configuration Release \
		-sdk macosx \
		build \
		CODE_SIGN_IDENTITY="-" \
		CONFIGURATION_BUILD_DIR="$(BUILD_DIR)"

install: build
	cp -r "$(SAVER)" "$(INSTALL)"
	@echo "Installed to $(INSTALL)"

clean:
	rm -rf "$(BUILD_DIR)"
