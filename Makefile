# Cross-platform (WSL, macOS, Linux) developer entry points. Requires: docker, uv, node 22+, pnpm.
COMPOSE := docker compose -f backend/compose.yaml

.DEFAULT_GOAL := help
.PHONY: help setup up down logs build migrate makemigrations shell superuser test-backend \
        web mobile lint format typecheck test check gen-api reset-db

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

setup: ## Install all dev dependencies and git hooks (run once)
	./scripts/setup.sh

## ---- Backend (Docker) ----
up: ## Start backend + Postgres (http://localhost:8000)
	$(COMPOSE) up --build

down: ## Stop the backend stack
	$(COMPOSE) down

logs: ## Tail backend logs
	$(COMPOSE) logs -f web

build: ## Rebuild backend image
	$(COMPOSE) build

migrate: ## Apply migrations
	$(COMPOSE) run --rm web python manage.py migrate

makemigrations: ## Create migrations
	$(COMPOSE) run --rm web python manage.py makemigrations

shell: ## Django shell
	$(COMPOSE) run --rm web python manage.py shell

superuser: ## Create a Django superuser
	$(COMPOSE) run --rm web python manage.py createsuperuser

reset-db: ## Destroy the local database volume
	$(COMPOSE) down -v

test-backend: ## Run backend tests in the container
	$(COMPOSE) run --rm web pytest

## ---- Frontend (host) ----
web: ## Start the web dev server (http://localhost:5173)
	pnpm dev:web

mobile: ## Start the Expo dev server (needs a dev client build)
	pnpm dev:mobile

gen-api: ## Regenerate TS API types from the running backend
	pnpm gen:api

## ---- Quality gates (same as CI) ----
lint: ## Lint backend + frontend
	cd backend && uv run ruff check . && uv run ruff format --check .
	pnpm lint

format: ## Auto-format backend + frontend
	cd backend && uv run ruff check --fix . && uv run ruff format .
	pnpm format

typecheck: ## Type-check backend + frontend
	cd backend && uv run mypy .
	pnpm typecheck

test: ## Run frontend tests (backend: make test-backend)
	pnpm test

check: lint typecheck test test-backend ## Everything CI runs
