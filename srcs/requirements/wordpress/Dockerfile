FROM debian:bullseye

# Temel araçlar ve PHP deposu
RUN apt-get update && apt-get install -y \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    wget \
    gnupg2 \
    unzip \
    git \
    curl \
    build-essential \
    libssl-dev \
    libz-dev \
    libnghttp2-dev \
    && curl --version

# Sury deposu (PHP için)
RUN curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /usr/share/keyrings/sury-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/sury-archive-keyring.gpg] https://packages.sury.org/php/ bullseye main" > /etc/apt/sources.list.d/php.list && \
    apt-get update

# PHP 8.0 ve gerekli eklentiler
RUN apt-get install -y \
    php8.0 \
    php8.0-cli \
    php8.0-cgi \
    php8.0-fpm \
    php8.0-mysql \
    php8.0-pdo \
    php8.0-gd \
    php8.0-mbstring \
    php8.0-xml \
    php8.0-curl \
    php8.0-redis \
    redis \
    bash && \
    rm -rf /var/lib/apt/lists/*




# WP-CLI kurulumu
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# PHP-FPM yapılandırması
COPY ./conf/www.conf /etc/php/8.0/fpm/pool.d/
RUN mkdir -p /run/php

# WordPress scripti
COPY ./tools/create_wordpress.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/create_wordpress.sh

WORKDIR /var/www/html/
EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/create_wordpress.sh"]
CMD ["/usr/sbin/php-fpm8.0", "-F"]