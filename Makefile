DC = docker compose -f ./srcs/docker-compose.yml

CREDENTIALS_FILE = secrets/credentials.txt
DB_PASSWORD_FILE = secrets/db_password.txt
DB_ROOT_PASSWORD_FILE = secrets/db_root_password.txt
ENV_FILE = ./srcs/.env
MARIADB_DATA_DIR = /home/debian/data/mariadb
WORDPRESS_DATA_DIR = /home/debian/data/wordpress

.DEFAULT_GOAL := deploy

create-env:
	@echo "📦 Creating environment file..."
	@if [ -f $(ENV_FILE) ]; then \
		echo "📦 Environment file already exists. Skipping creation."; \
	else \
		echo "❌ Error: $(ENV_FILE) file is missing. Please create it manually."; \
		exit 1; \
	fi
	# Backup existing .env if it exists
	@if [ -f $(ENV_FILE) ]; then \
		echo "💾 Backing up existing .env file..."; \
		cp $(ENV_FILE) $(ENV_FILE).backup; \
	fi
	
	# Create new .env file if it doesn't exist
	@if [ ! -f $(ENV_FILE) ]; then \
		touch $(ENV_FILE); \
	fi
	
	@if [ -f $(CREDENTIALS_FILE) ]; then \
		echo "➕ Adding credentials..."; \
		grep -q -f $(CREDENTIALS_FILE) $(ENV_FILE) || cat $(CREDENTIALS_FILE) >> $(ENV_FILE); \
		echo "" >> $(ENV_FILE); \
	else \
		echo "⚠️ $(CREDENTIALS_FILE) bulunamadı"; \
	fi
	
	@if [ -f $(DB_PASSWORD_FILE) ]; then \
		echo "➕ Adding database password..."; \
		grep -q -f $(DB_PASSWORD_FILE) $(ENV_FILE) || cat $(DB_PASSWORD_FILE) >> $(ENV_FILE); \
		echo "" >> $(ENV_FILE); \
	else \
		echo "⚠️ $(DB_PASSWORD_FILE) bulunamadı"; \
	fi
	
	@if [ -f $(DB_ROOT_PASSWORD_FILE) ]; then \
		echo "➕ Adding database root password..."; \
		grep -q -f $(DB_ROOT_PASSWORD_FILE) $(ENV_FILE) || cat $(DB_ROOT_PASSWORD_FILE) >> $(ENV_FILE); \
		echo "" >> $(ENV_FILE); \
	else \
		echo "⚠️ $(DB_ROOT_PASSWORD_FILE) bulunamadı"; \
	fi
	
	@echo "✅ Environment file updated successfully!"

.PHONY: deploy
deploy: create-env
	@if [ ! -f $(CREDENTIALS_FILE) ]; then \
		echo "❌ Error: $(CREDENTIALS_FILE) file is missing. Please create it in the secrets folder."; \
		exit 1; \
	fi
	@if [ ! -f $(DB_PASSWORD_FILE) ]; then \
		echo "❌ Error: $(DB_PASSWORD_FILE) file is missing. Please create it in the secrets folder."; \
		exit 1; \
	fi
	@if [ ! -f $(DB_ROOT_PASSWORD_FILE) ]; then \
		echo "❌ Error: $(DB_ROOT_PASSWORD_FILE) file is missing. Please create it in the secrets folder."; \
		exit 1; \
	fi
	@if [ ! -d $(MARIADB_DATA_DIR) ]; then \
		echo "📂 Creating MariaDB data directory..."; \
		mkdir -p $(MARIADB_DATA_DIR); \
	fi
	@if [ ! -d $(WORDPRESS_DATA_DIR) ]; then \
		echo "📂 Creating WordPress data directory..."; \
		mkdir -p $(WORDPRESS_DATA_DIR); \
	fi
	@echo "🚀 Starting services with Docker Compose..."
	@$(DC) up -d --build

.PHONY: all
all: deploy

.PHONY: down
down:
	@echo "🛑 Stopping services..."
	@$(DC) down

.PHONY: clean
clean:
	@echo "🧹 Cleaning up containers, volumes, networks, and orphans..."
	@$(DC) down -v --remove-orphans
	@echo "🧨 Removing unused images..."
	@docker image prune -a -f
	@echo "🧹 Removing unused volumes..."
	@docker volume prune -f
	@echo "🧨 Removing unused networks..."
	@docker network prune -f
	@echo "🧼 Removing dangling build cache..."
	@docker builder prune -f
	@echo "💾 Removing Mount directories build cache..."
	rm -rf $(WORDPRESS_DATA_DIR)
	rm -rf $(MARIADB_DATA_DIR)

.PHONY: fclean
fclean: clean
	@echo "🚨 Forcing removal of all containers and volumes"
	@docker ps -aq | xargs -r docker rm -f || true
	@docker volume ls -q | xargs -r docker volume rm -f || true
	@docker rmi -f $(shell docker images -aq) 2>/dev/null || true
	@echo "⚠️ All containers, volumes, networks, and images have been removed."