#!/bin/bash
mysqld_safe &
sleep 3

until mysqladmin ping --silent; do
sleep 1
done

if ! mysql -u root -e "USE ${MYSQL_DATABASE};" 2>/dev/null; then
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
fi

mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
exec mysqld_safe
