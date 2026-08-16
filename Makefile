.PHONY: help install develop build publish clean test lint

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install via pip (user install)
	pip install --user -e .

develop: ## Install in editable mode
	pip install -e .

build: ## Build PyPI package
	pip install --quiet build
	python -m build

publish: build ## Build and publish to PyPI
	pip install --quiet twine
	python -m twine upload dist/*

publish-test: build ## Build and publish to TestPyPI
	pip install --quiet twine
	python -m twine upload --repository testpypi dist/*

clean: ## Remove build artifacts
	rm -rf dist/ build/ *.egg-info src/*.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true

test: ## Run skill tests
	bash tests/run-skill-tests.sh

lint: ## Lint shell scripts
	shellcheck scripts/*.sh hooks/*/*.sh tests/*.sh tests/skills/*.sh

pipx-install: build ## Install via pipx from local build
	pipx install --force dist/*.tar.gz

pipx-uninstall: ## Uninstall via pipx
	pipx uninstall cybersec-superpowers

one-click: ## Simulate one-click install
	bash install.sh

demo: ## Run demo project
	bash examples/demo-project/run-demo.sh