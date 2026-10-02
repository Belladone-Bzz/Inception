# Developer Documentation

## Purpose

This document explains how to reproduce, build, run, inspect and maintain the Inception infrastructure from a development environment.

The project is built with Docker Compose and contains three custom-built services:

- NGINX
- WordPress + PHP-FPM
- MariaDB

The services communicate through the `inception` Docker network.

## Prerequisites

The activity is designed to run inside the required virtual machine.

Install and verify:

```bash
docker --version
docker compose version
make --version
```

## Configuration files

Create the local environment file:

```bash
cp srcs/.env_example srcs/.env
```

Configure:

```text
DOMAIN_NAME=user.42.fr

MYSQL_DATABASE=...
MYSQL_USER=...
MYSQL_PASSWORD=...
MYSQL_ROOT_PASSWORD=...

WP_TITLE=...
WP_ADMIN_USER=...
WP_ADMIN_PASSWORD=...
WP_ADMIN_EMAIL=...

WP_USER=...
WP_USER_PASSWORD=...
WP_USER_EMAIL=...
```

The actual `.env` must not be committed to Git. The public repository contains `.env_example` instead of the real credentials.

## Build and launch

From the repository root:

```bash
make
```

The Makefile runs Docker Compose with `srcs/docker-compose.yml`. The Compose file builds the three services from their own Dockerfiles.

## Makefile commands

```bash
# Build and start
make
```

```bash
# Stop
make down
```

```bash
# Rebuild
make re
```

```bash
# Clean Docker resources
make clean
```

```bash
# Full cleanup
make fclean
```

The cleanup targets must be used carefully because they remove Docker resources and persistent data.

## Docker Compose services

### MariaDB

MariaDB is built from `srcs/requirements/mariadb/Dockerfile`. Its configuration is in `srcs/requirements/mariadb/conf/mariadb.cnf`. Its initialization script is `srcs/requirements/mariadb/tools/init.sh`. The database is stored in `/var/lib/mysql` and persisted through the `db_data` named volume.


### WordPress

WordPress is built from `srcs/requirements/wordpress/Dockerfile`. PHP-FPM configuration is in `srcs/requirements/wordpress/conf/www.conf`. Its initialization script is
`srcs/requirements/wordpress/tool/init.sh`. The WordPress application files are stored in `/var/www/html` and persisted through the `wp_files` named volume. PHP-FPM listens on port 9000.

### NGINX

NGINX is built from `srcs/requirements/nginx/Dockerfile`. Its configuration is in `srcs/requirements/nginx/conf/nginx.conf`. Its initialization script is `srcs/requirements/nginx/tools/init.sh`. NGINX is the only service publishing a host port `443:443`. TLS is restricted to: TLSv1.2 and TLSv1.3. NGINX forwards PHP requests to: wordpress:9000.

## Service communication

The Docker network is `inception`. The important communication paths are:

```text
Host
 |
 | HTTPS :443
 v
NGINX
 |
 | FastCGI :9000
 v
WordPress/PHP-FPM
 |
 | MySQL :3306
 v
MariaDB
```

The services use Docker's internal DNS. Therefore `wordpress` resolves to the WordPress container, and `mariadb` resolves to the MariaDB container. Using service names is preferable to hard-coding container IP addresses because IP addresses may change when containers are recreated.

## Container commands

```bash
# List all containers:
docker ps -a
```

```bash
# View logs:
docker compose -f srcs/docker-compose.yml logs
```

```bash
# Follow logs:
docker compose -f srcs/docker-compose.yml logs -f
```

```bash
# Inspect a service:
docker inspect nginx
docker inspect wordpress
docker inspect mariadb
```

```bash
# Open a shell inside a running container when required for debugging:
docker exec -it nginx /bin/bash
docker exec -it wordpress /bin/bash
docker exec -it mariadb /bin/bash
```

## Data storage

```bash
# List volumes:
docker volume ls
```

```bash
# Inspect:
docker volume inspect db_data
docker volume inspect wp_files
```

The two persistent storages are `db_data`(/var/lib/mysql) and `wp_files`(/var/www/html). Their host-side location is configured under `/home/<user>/data/`. Containers are replaceable. Volumes contain the persistent data. Therefore if we remove a container, the data remains in volume. If a new container mounts the same volume, the data is available again.


Removing the volumes is different. If we use :

```bash
docker compose down -v
```

This remove persistent data. It should not be used when the objective is simply to recreate containers.
