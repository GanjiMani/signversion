.PHONY: backend-install backend-run frontend-install frontend-run help docker-build docker-up docker-down docker-logs test

help:
	@echo "SignVision Makefile Commands:"
	@echo "  make backend-install  - Install backend dependencies"
	@echo "  make backend-run     - Run backend server"
	@echo "  make frontend-install - Install frontend dependencies"
	@echo "  make frontend-run    - Run frontend development server"
	@echo "  make docker-build    - Build Docker images"
	@echo "  make docker-up       - Start all services with Docker Compose"
	@echo "  make docker-down     - Stop all services"
	@echo "  make docker-logs     - View Docker logs"
	@echo "  make test            - Run tests"

backend-install:
	@echo "Installing backend dependencies..."
	cd signvision-backend && python -m venv venv || true
	cd signvision-backend && . venv/Scripts/activate && pip install --upgrade pip && pip install -r requirements.txt || cd signvision-backend && . venv/bin/activate && pip install --upgrade pip && pip install -r requirements.txt

backend-run:
	@echo "Starting backend server..."
	cd signvision-backend && . venv/Scripts/activate && uvicorn main:app --reload --host 0.0.0.0 --port 8000 || cd signvision-backend && . venv/bin/activate && uvicorn main:app --reload --host 0.0.0.0 --port 8000

frontend-install:
	@echo "Installing frontend dependencies..."
	cd signvision-frontend && npm install

frontend-run:
	@echo "Starting frontend development server..."
	cd signvision-frontend && npm run dev

docker-build:
	@echo "Building Docker images..."
	docker-compose build

docker-up:
	@echo "Starting services with Docker Compose..."
	docker-compose up -d

docker-down:
	@echo "Stopping services..."
	docker-compose down

docker-logs:
	@echo "Viewing Docker logs..."
	docker-compose logs -f

test:
	@echo "Running tests..."
	cd signvision-backend && python -m pytest tests/ -v
