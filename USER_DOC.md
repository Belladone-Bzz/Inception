# User Documentation

## Overview
This project provides a small WordPress website infrastructure composed of three services:

| Service | Role | Exposition |
|---|---|---|
| NGINX | HTTPS entry point and web server | Yes, port 443 |
| WordPress + PHP-FPM | WordPress application and PHP execution | No |
| MariaDB | WordPress database | No |

The three services communicate through a dedicated Docker network. The persistent data is stored in two Docker named volumes:  `wp_files` for the WordPress website files and `db_data` for the MariaDB database.

## Start the infrastructure
Make sure the local environment file exists:

```bash
cp srcs/.env_example srcs/.env
```

Edit `srcs/.env` with the required configuration and credentials. Then start the project from the repository root:

```bash
make
```

The Makefile builds the custom images and starts the containers in detached mode. Check that all three services are running with:

```bash
docker compose -f srcs/docker-compose.yml ps
```

## Access the website

The website is accessed through HTTPS:

```text
https://<user>.42.fr
```

The infrastructure exposes only port `443`. The browser connects to NGINX. NGINX then communicates internally with the WordPress container. If the domain does not resolve automatically on the VM, verify that the required `<user>.42.fr` entry points to the local IP address according to the activity setup.

## 5. Access the WordPress administration panel

The WordPress administration interface is available at:

```text
https://<user>.42.fr/wp-admin
```

Use the administrator credentials configured in the local `.env` file.

## Stop the activity

To stop and remove the containers:

```bash
make stop
make fclean
```

## 6. Credentials

Credentials are configured locally through:

```text
srcs/.env
```

The public repository contains only the example configuration:

```text
srcs/.env_example
```

Never commit real passwords to Git.

The main credential variables are:

```text
MYSQL_PASSWORD
MYSQL_ROOT_PASSWORD

WP_ADMIN_PASSWORD
WP_USER_PASSWORD
```

Other variables identify the database, WordPress users and site configuration.

## 7. Check that the services are running

Use:

```bash
docker compose -f srcs/docker-compose.yml ps
```

Check the logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

Check one service:

```bash
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
docker compose -f srcs/docker-compose.yml logs mariadb
```

Follow logs in real time:

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

## 8. Check the containers individually

```bash
docker ps
```

The expected services are:

```text
nginx
wordpress
mariadb
```

To inspect a container:

```bash
docker inspect nginx
docker inspect wordpress
docker inspect mariadb
```

## 9. Check the Docker network

The services communicate through the `inception` network.

List networks:

```bash
docker network ls
```

Inspect it:

```bash
docker network inspect inception
```

The three service containers should be connected to this network.

## 10. Check persistent storage

List Docker volumes:

```bash
docker volume ls
```

Inspect the project volumes:

```bash
docker volume inspect db_data
docker volume inspect wp_files
```

The two volumes contain different types of persistent data:

```text
db_data -> MariaDB database

wp_files -> WordPress website files
```

The host-side data is configured under:

```text
/home/<user>/data/
```

## 11. Persistence test

To verify that application data survives container recreation:

1. Create or modify some WordPress data.
2. Stop the project:

```bash
make down
```

3. Start it again:

```bash
make
```

4. Check the website and WordPress data.

The named volumes should preserve the persistent data.
