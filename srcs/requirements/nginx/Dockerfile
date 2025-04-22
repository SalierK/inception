FROM debian:buster

# Gerekli araçları ve PHP'yi kur
RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    gnupg2 \
    ca-certificates \
    unzip \
    libnss3-tools \
    openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# mkcert'i kur
RUN curl -LO https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64 \
    && chmod +x mkcert-v1.4.3-linux-amd64 \
    && mv mkcert-v1.4.3-linux-amd64 /usr/local/bin/mkcert

# SSL dizinini oluştur
RUN mkdir -p /etc/nginx/ssl

# Nginx config dosyasını kopyala
COPY ./conf/nginx.conf /etc/nginx/sites-enabled/default

# Sertifikaları oluşturacak scripti kopyala
COPY ./tools/nginx_start.sh /var/www/

# Script'i çalıştırılabilir yap
RUN chmod +x /var/www/nginx_start.sh

# Çalışma dizinini ayarla
WORKDIR /var/www/

# Nginx'in çalışabilmesi için gerekli dizini oluştur
RUN mkdir -p /run/nginx

# Giriş scripti olarak nginx_start.sh'i ayarla
ENTRYPOINT ["/var/www/nginx_start.sh"]

# Nginx için gerekli portları aç
EXPOSE 443

# Nginx'i başlat
CMD ["nginx", "-g", "daemon off;"]
