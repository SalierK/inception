#!/bin/bash
set -e  # Exit on any error

# Function to handle errors
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Check if WordPress is already installed
if [ -f ./wp-config.php ]; then
    echo "WordPress already downloaded"
else
    echo "Downloading and setting up WordPress..."
    
    # Download WordPress
    wget http://wordpress.org/latest.tar.gz || error_exit "Failed to download WordPress"
    
    # Extract and move files
    tar xfz latest.tar.gz || error_exit "Failed to extract WordPress"
    mv wordpress/* . || error_exit "Failed to move WordPress files"
    
    # Cleanup
    rm -rf latest.tar.gz wordpress
    
    # Verify required environment variables
    if [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_HOSTNAME" ] || [ -z "$MYSQL_DATABASE" ]; then
        error_exit "Required environment variables not set"
    fi
    
    # Configure WordPress
    if [ ! -f wp-config-sample.php ]; then
        error_exit "wp-config-sample.php not found"
    fi
    
    sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
    sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
    sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
    sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
    
    cp wp-config-sample.php wp-config.php || error_exit "Failed to create wp-config.php"
    
    echo "WordPress setup completed successfully"
fi

exec "$@"