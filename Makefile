export EXECUTABLE_NAME = swift-dotenv
PREFIX = /usr/local
INSTALL_PATH = $(PREFIX)/bin/swift-dotenv
CURRENT_PATH = $(PWD)
SWIFT_BUILD_FLAGS = --disable-sandbox -c release
EXECUTABLE_PATH = $(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path)/$(EXECUTABLE_NAME)

build:
	swift build $(SWIFT_BUILD_FLAGS)

install: build
	mkdir -p $(PREFIX)/bin
	sudo cp -f $(EXECUTABLE_PATH) $(INSTALL_PATH)
