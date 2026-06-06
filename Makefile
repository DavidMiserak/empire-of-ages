# Empire of Ages — Makefile
# Flutter Casual Games Toolkit + Flame, fvm-pinned SDK

# Use the fvm-pinned Flutter / Dart so this works regardless of system PATH
FVM     := $(HOME)/fvm/bin/fvm
FLUTTER := $(FVM) flutter
DART    := $(FVM) dart

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "Empire of Ages — development commands"
	@echo "====================================="
	@echo ""
	@echo "Environment:"
	@echo "  make doctor            Run flutter doctor (verify SDK + toolchains)"
	@echo "  make devices           List devices flutter can launch on"
	@echo "  make pub-get           Resolve Flutter/Dart dependencies"
	@echo "  make pre-commit-setup  Install pre-commit hooks"
	@echo ""
	@echo "Run (interactive — hot reload):"
	@echo "  make run               Run on first available device"
	@echo "  make run-linux         Run on Linux desktop (GTK window)"
	@echo "  make run-web           Run in Chrome (web build with hot reload)"
	@echo "  make run-android       Run on a connected/emulated Android device"
	@echo ""
	@echo "Quality:"
	@echo "  make test              Run unit + widget tests"
	@echo "  make analyze           Run flutter analyze (lints)"
	@echo "  make format            Format lib/ + test/ with dart format"
	@echo ""
	@echo "Build:"
	@echo "  make build-apk         Build release APK (android/)"
	@echo "  make build-web         Build release web bundle (build/web/)"
	@echo "  make serve-web         Serve build/web/ at http://localhost:8000"
	@echo "  make clean             flutter clean (wipes build/, .dart_tool/)"

# --- environment ---

.PHONY: doctor
doctor:
	$(FLUTTER) doctor

.PHONY: devices
devices:
	$(FLUTTER) devices

.PHONY: pub-get
pub-get:
	$(FLUTTER) pub get

.PHONY: pre-commit-setup
pre-commit-setup:
	pre-commit install
	pre-commit install --install-hooks
	pre-commit run --all-files

# --- run ---

.PHONY: run
run:
	$(FLUTTER) run

.PHONY: run-linux
run-linux:
	$(FLUTTER) run -d linux

.PHONY: run-web
run-web:
	$(FLUTTER) run -d chrome

.PHONY: run-android
run-android:
	$(FLUTTER) run -d $(shell $(FLUTTER) devices 2>/dev/null | grep android | awk '{print $$4}')

# --- quality ---

.PHONY: test
test:
	$(FLUTTER) test

.PHONY: analyze
analyze:
	$(FLUTTER) analyze

.PHONY: format
format:
	$(DART) format lib/ test/

# --- build ---

.PHONY: build-apk
build-apk:
	$(FLUTTER) build apk --release

.PHONY: build-web
build-web:
	$(FLUTTER) build web --release

.PHONY: serve-web
serve-web: build-web
	@echo "Serving build/web/ at http://localhost:8000 (Ctrl+C to stop)"
	@cd build/web && python -m http.server 8000

.PHONY: clean
clean:
	$(FLUTTER) clean
