# Variables
PYTHON = python
PIP = pip
POETRY = poetry

# Default target
.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: ## Install poetry
	sudo apt-get update
	sudo apt-get install -y python3-pip make
	$(PIP) install poetry

.PHONY: install
install: ## Install dependencies
	$(POETRY) install

.PHONY: update
update: ## Update dependencies
	$(POETRY) update

.PHONY: test
test: ## Run tests
	$(POETRY) run pytest

.PHONY: lint
lint: ## Run ruff lint
	$(POETRY) run ruff check .

.PHONY: format
format: ## Format code with ruff
	$(POETRY) run ruff format .

.PHONY: typecheck
typecheck: ## Typecheck code with mypy
	$(POETRY) run mypy .

.PHONY: clean
clean: ## Clean up generated files
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -exec rm -r {} +
	rm -rf .mypy_cache
	rm -rf .pytest_cache
	rm -rf .ruff_cache
	rm -rf .coverage
	rm -rf htmlcov
	rm -rf coverage.xml
	rm -rf junit

.PHONY: coverage
coverage: ## Run tests with coverage
	$(POETRY) run pytest --cov=src --cov-report=term-missing

.PHONY: codecov
codecov: ## Upload coverage report to codecov
	$(POETRY) run pytest --cov=src --cov-branch --cov-report=xml

.PHONY: build
build: ## Build the library
	$(POETRY) build

.PHONY: publish
publish: ## Publish the library to PyPI (requires PYPI_TOKEN to be set)
	$(POETRY) config pypi-token.pypi $(PYPI_TOKEN)
	$(POETRY) publish --build

.PHONY: check
check: lint mypy test ## Run lint, typecheck, and tests

.PHONY: precommit
precommit: ## Install and run pre-commit hooks
	$(POETRY) run pre-commit install
	$(POETRY) run pre-commit run --all-files

.PHONY: all
all: install check build ## Install dependencies, run checks, and build the library
