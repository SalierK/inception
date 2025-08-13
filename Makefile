DC := docker compose -f ./srcs/docker-compose.yml
DATA_DIR := /home/data

all: setup
	@$(DC) up -d --build

setup:
	@echo "Creating data directories..."
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mysql

down:
	@$(DC) down

stop:
	@$(DC) stop

start:
	@$(DC) start

logs:
	@$(DC) logs -f

status:
	@$(DC) ps

re: clean all

clean:
	@echo "Stopping containers and removing volumes..."
	@$(DC) down -v --remove-orphans
	@echo "Removing unused images..."
	@if [ "$$(docker images -q)" != "" ]; then docker rmi -f $$(docker images -q); fi

fclean: clean
	@echo "Removing data directories..."
	@sudo rm -rf $(DATA_DIR)/wordpress
	@sudo rm -rf $(DATA_DIR)/mysql

rebuild:
	@$(DC) build --no-cache

help:
	@echo "Available targets:"
	@echo "  all      - Setup and start all services"
	@echo "  setup    - Create necessary directories"
	@echo "  down     - Stop and remove containers"
	@echo "  stop     - Stop containers"
	@echo "  start    - Start stopped containers"
	@echo "  logs     - Follow container logs"
	@echo "  status   - Show container status"
	@echo "  re       - Clean and rebuild"
	@echo "  clean    - Remove containers and images"
	@echo "  fclean   - Full clean including data"
	@echo "  rebuild  - Rebuild without cache"
	@echo "  help     - Show this help"

.PHONY: all setup down stop start logs status re clean fclean rebuild help