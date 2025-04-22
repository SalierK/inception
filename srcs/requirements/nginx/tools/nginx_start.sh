#!/bin/bash

SSL_DIR="/etc/nginx/ssl"
CRT="$SSL_DIR/kkilitci.42.fr.crt"
KEY="$SSL_DIR/kkilitci.42.fr.key"
CA="$SSL_DIR/rootCA.pem"  # Root CA sertifikası

# Sertifika ve CA zaten mevcutsa, oluşturma işlemi yapılmaz
if [ ! -f "$CRT" ] || [ ! -f "$KEY" ]; then
    echo "Nginx: SSL sertifikaları bulunamadı. mkcert ile oluşturuluyor..."

    # Sertifika yetkilisini (CA) kur
    mkcert -install

    # Sertifikayı oluştur
    mkcert -cert-file "$CRT" -key-file "$KEY" kkilitci.42.fr

    # Root CA sertifikasını al ve konteynerin güvenilir sertifikalar dizinine kopyala
    cp $(mkcert -CAROOT)/rootCA.pem $CA

    echo "Nginx: SSL sertifikaları oluşturuldu ve hazır!"
else
    echo "Nginx: SSL sertifikaları zaten mevcut."
fi

# Root CA'yı sistemin güvenilir sertifikalar listesine ekle
cp $CA /usr/local/share/ca-certificates/rootCA.crt
update-ca-certificates

# Nginx'i başlat
exec "$@"
