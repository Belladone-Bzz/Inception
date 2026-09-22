#!/bin/bash

# Download WordPress
wget -q https://wordpress.org/latest.tar.gz -P /tmp
tar -xzf /tmp/latest.tar.gz -C /tmp
mkdir -p /var/www/html
mv /tmp/wordpress/* /var/www/html/

# Download WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

until (echo > /dev/tcp/mariadb/3306) 2>/dev/null; do sleep 1; done
# make sure database is ready

if [ ! -f /var/www/html/wp-config.php ]; then
    wp config create \
    --dbname=${MYSQL_DATABASE} \
    --dbuser=${MYSQL_USER} \
    --dbpass=${MYSQL_PASSWORD} \
    --dbhost=mariadb:3306 \
    --path=/var/www/html \
    --allow-root

    wp config set WP_HOME "https://${DOMAIN_NAME}" --path=/var/www/html --allow-root
    wp config set WP_SITEURL "https://${DOMAIN_NAME}" --path=/var/www/html --allow-root

    wp core install \
    --url=${DOMAIN_NAME} \
    --title=${WP_TITLE} \
    --admin_user=${WP_ADMIN_USER} \
    --admin_password=${WP_ADMIN_PASSWORD} \
    --admin_email=${WP_ADMIN_EMAIL} \
    --path=/var/www/html \
    --allow-root

    wp user create ${WP_USER} ${WP_USER_EMAIL} \
    --role=editor \
    --user_pass=${WP_USER_PASSWORD} \
    --path=/var/www/html \
    --allow-root
fi

mkdir -p /run/php
exec /usr/sbin/php-fpm8.2 -F