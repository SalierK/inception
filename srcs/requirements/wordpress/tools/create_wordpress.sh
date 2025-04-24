#!/bin/sh

# if [ -f ./wp-config.php ]
# then
# 	echo "Wordpress already downloaded"
# else
# 	wget http://wordpress.org/latest.tar.gz
# 	tar xfz latest.tar.gz
# 	mv wordpress/* .
# 	rm -rf latest.tar.gz
# 	rm -rf wordpress

# 	sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
# 	sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
# 	sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
# 	sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
# 	cp wp-config-sample.php wp-config.php
# fi

# if [ ! -f wp-config.php ]; then
#     wp core download --allow-root
#     wp config create \
#         --dbname=wordpress \
#         --dbuser=kkilitci \
#         --dbpass=kkilitcips \
#         --dbhost=mariadb:3306 \
#         --allow-root
#     wp core install \
#         --url=https://localhost:443 \
#         --title="To The End Of İnception" \
#         --admin_user=admin \
#         --admin_password=rootkkilitci \
#         --admin_email=admin@example.com \
#         --skip-email \
#         --allow-root
# fi

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
chmod 777 -R wp-includes/
chmod 777 -R wp-admin/
chmod 777 -R license.txt 
chmod 777 -R readme.html
mv wp-cli.phar /usr/local/bin/wp
mkdir wp-content/upgrade
chmod 777 -R wp-content/upgrade
echo "127.0.0.1 kkilitci.42.fr" | tee -a /etc/hosts > /dev/null
mkdir wp-content/upgrade-temp-backup 

chown -R www-data:www-data /var/www/html
	wp core download --allow-root
	wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --dbhost=mariadb:3306 --allow-root
	wp core install --url=https://kkilitci.42.fr:443 --title="To The End Of İnception" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=admin@example.com --allow-root
	wp option update permalink_structure '/%postname%/' --allow-root
	wp user create "$WP_USER" "$WP_USER@example.com" --role=subscriber --user_pass="$WP_PASSWORD" --allow-root
sed -i "/\/\* That's all, stop editing! Happy publishing. \*\//i define('FS_METHOD', 'direct');" wp-config.php
sed -i "/\/\* That's all, stop editing! Happy publishing. \*\//i define('WP_HOME', 'https://kkilitci.42.fr');" wp-config.php
sed -i "/\/\* That's all, stop editing! Happy publishing. \*\//i define('WP_SITEURL', 'https://kkilitci.42.fr');" wp-config.php
exec "$@" 