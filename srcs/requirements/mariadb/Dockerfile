FROM debian:buster

# Install MariaDB and clean up apt cache
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration files
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/
COPY ./tools/init_db.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init_db.sh

# Add health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD mysqladmin ping -h localhost || exit 1

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init_db.sh"]
CMD ["mysqld"]