# Load the environment variables in the .env file if it exists
ifneq (,$(wildcard ./.env))
    include .env
    export $(shell sed 's/=.*//' .env)
else
    $(warning .env file not found. No environment variables loaded.)
endif

# Variables
PYTHON         := python
PIP            := pip
POETRY         := poetry
GUNICORN       := gunicorn
NUM_WORKERS    := 4
PORT           := 8000
HOST           := 0.0.0.0
FLASK_APP      := src.app:app
FLASK_APP_DIR  := src.app
DB_DIR         := src/db
SHELL          := /bin/bash
MANAGER := src.manage
IMAGE_NAME := my-flask-app-image
CONTAINER_NAME := my-flask-app

# Default target
.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | \
    awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

####################################################################################################
## Python Targets
####################################################################################################

.PHONY: setup
setup: ## Install dependencies (requires sudo)
	@sudo apt-get update
	@sudo apt-get install -y python3-pip docker-compose
	$(PIP) install poetry

.PHONY: install
install: ## Install Python dependencies for production
	@$(POETRY) install --no-root

.PHONY: install-dev
install-dev: ## Install Python dependencies for development
	@$(POETRY) install --no-root --all-extras

.PHONY: update
update: ## Update Python dependencies
	@$(POETRY) update

.PHONY: test
test: ## Run the tests
	@$(POETRY) run pytest

.PHONY: lint
lint: ## Run the linter checks (with autofix enabled)
	@$(POETRY) run ruff check --fix .

.PHONY: format
format: ## Format the Python code
	@$(POETRY) run ruff format .

.PHONY: typecheck
typecheck: ## Typecheck Python code
	@$(POETRY) run mypy -p src

.PHONY: clean
clean: ## Remove temporary files and directories
	@find . -type f -name '*.pyc' -delete
	@find . -type d -name '__pycache__' -exec rm -r {} +
	@rm -rf .mypy_cache .pytest_cache .ruff_cache .coverage htmlcov coverage.xml junit

.PHONY: cov
cov: ## Run tests with code coverage
	@$(POETRY) run pytest --cov=src --cov-report=term-missing

.PHONY: codecov
codecov: ## Generate XML code coverage report for Codecov
	@$(POETRY) run pytest --cov=src --cov-branch --cov-report=xml

.PHONY: check
check: lint test typecheck ## Run lint, tests, and typecheck

.PHONY: all
all: install check ## Install dependencies and run checks

####################################################################################################
## Flask Targets
####################################################################################################

.PHONY: make-admin
make-admin: ## Make a user an admin (e.g., make make-admin ADMIN_USER=<username>)
	@if [ -z "$(ADMIN_USER)" ]; then \
		echo "Usage: make make-admin ADMIN_USER=<username>"; \
		exit 1; \
	fi
	@$(POETRY) run flask --app $(MANAGER) make-admin $(ADMIN_USER)

.PHONY: run
run: ## Run the application with Gunicorn
	@$(POETRY) run $(GUNICORN) -w $(NUM_WORKERS) -b $(HOST):$(PORT) $(FLASK_APP)

.PHONY: run-dev
run-dev: ## Run the app with the Flask development server
	@$(POETRY) run flask --app $(FLASK_APP) run --host=$(HOST) --port=$(PORT) --reload --debug

.PHONY: db-init
db-init: ## Initialize the database migrations directory
	@mkdir -p $(DB_DIR)/instance
	@$(POETRY) run flask --app $(FLASK_APP_DIR) db init -d $(DB_DIR)/migrations

.PHONY: db-migrate
db-migrate: ## Generate a new database migration
	@$(POETRY) run flask --app $(FLASK_APP_DIR) db migrate -m "Database migration" -d $(DB_DIR)/migrations

.PHONY: db-upgrade
db-upgrade: ## Apply the latest database migrations
	@$(POETRY) run flask --app $(FLASK_APP_DIR) db upgrade -d $(DB_DIR)/migrations

.PHONY: db-downgrade
db-downgrade: ## Rollback the last applied migration
	@$(POETRY) run flask --app $(FLASK_APP_DIR) db downgrade -d $(DB_DIR)/migrations

.PHONY: db-reset
db-reset: ## Drop and recreate the database (DANGER: Deletes all data!)
	@$(SHELL) -c 'read -p "Are you sure you want to reset the database? [y/N] " -n 1 -r; \
	echo ""; \
	if [[ ! $$REPLY =~ ^[Yy]$$ ]]; then \
		echo "Reset cancelled"; \
		exit 1; \
	else \
		rm -rf $(DB_DIR)/instance $(DB_DIR)/migrations; \
		$(MAKE) db-init; \
		$(MAKE) db-migrate; \
		$(MAKE) db-upgrade; \
	fi'

####################################################################################################
## Docker Targets
####################################################################################################

.PHONY: docker-build
docker-build: ## Build the Docker image (removes the existing image first)
	@docker rmi $(IMAGE_NAME) || true
	@docker build --no-cache -t $(IMAGE_NAME) .

.PHONY: docker-up
docker-up: ## Start the Docker container using docker-compose
	@docker-compose up -d

.PHONY: docker-down
docker-down: ## Stop the Docker container using docker-compose
	@docker-compose down

.PHONY: docker-restart
docker-restart: ## Restart the Docker container
	@$(MAKE) docker-down
	@$(MAKE) docker-up

.PHONY: docker-shell
docker-shell: ## Open a bash shell in the running container
	@docker-compose exec $(CONTAINER_NAME) /bin/bash
