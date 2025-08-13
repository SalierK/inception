#!/bin/bash
set -e  # Exit on any error

# Function to handle errors
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Generate SSL certificate if it doesn't exist
if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
    echo "Nginx: setting up ssl ..."
    openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/C=TR/ST=KOCAELI/L=GEBZE/O=42Kocaeli/CN=ehazir.42.fr" \
        || error_exit "Failed to generate SSL certificate"
    
    # Set proper permissions
    chmod 600 /etc/nginx/ssl/nginx.key
    chmod 644 /etc/nginx/ssl/nginx.crt
    
    echo "Nginx: ssl is set up!"
fi

# Test nginx configuration
nginx -t || error_exit "Nginx configuration test failed"

exec "$@"