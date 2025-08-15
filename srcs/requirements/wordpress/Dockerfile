FROM debian:buster

# Install packages in a single layer and clean up apt cache
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    bash \
    php \
    php-cgi \
    php-mysql \
    php-fpm \
    php-pdo \
    php-gd \
    php-cli \
    php-mbstring \
    redis \
    php-redis \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /run/php

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy configuration files and scripts
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/
COPY ./tools/create_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/create_wordpress.sh

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=30s --retries=3 \
    CMD pgrep php-fpm7.3 || exit 1

WORKDIR /var/www/html/
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/create_wordpress.sh"]
CMD ["/usr/sbin/php-fpm7.3", "-F"]