# file: Makefile
.PHONY: help
help:
	@echo "Project Development Commands"
	@echo "============================"
	@echo ""
	@echo "Development Setup:"
	@echo "  pre-commit-setup    Set up pre-commit hooks for the project"

.PHONY: pre-commit-setup
pre-commit-setup:
	@echo "Setting up pre-commit hooks..."
	@echo "consider running <pre-commit autoupdate> to get the latest versions"
	pre-commit install
	pre-commit install --install-hooks
	pre-commit run --all-files
