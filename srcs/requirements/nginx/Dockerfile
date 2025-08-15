FROM debian:buster

# Install packages in a single layer and clean up apt cache
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/nginx/ssl /run/nginx

# Copy configuration files
COPY ./conf/nginx.conf /etc/nginx/sites-enabled/default
COPY ./tools/nginx_start.sh /var/www/

# Set executable permissions
RUN chmod +x /var/www/nginx_start.sh

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD curl -k -f https://localhost:443/ || exit 1

EXPOSE 443

ENTRYPOINT ["/var/www/nginx_start.sh"]
CMD ["nginx", "-g", "daemon off;"]