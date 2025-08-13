#!/bin/bash
set -e  # Exit on any error

# Function to handle errors
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

echo "Initializing MariaDB database..."

# Start MySQL service
service mysql start || error_exit "Failed to start MySQL service"

# Create database and user using environment variables
mysql << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
EOF

echo "Database initialization completed successfully"

# Stop the service (it will be started by CMD)
service mysql stop

exec "$@"