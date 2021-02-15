#! /bin/sh
# https://fedoramagazine.org/nextcloud-20-on-fedora-linux-with-podman/

# Creating a new network
podman network create nextcloud-net

# Listing all networks
podman network ls

# Inspecting a network
podman network inspect nextcloud-net

# Creating the volumes
podman volume create nextcloud-app
podman volume create nextcloud-data
podman volume create nextcloud-db

# Listing volumes
podman volume ls

# Inspecting volumes (this also provides the full path)
podman volume inspect nextcloud-app

# Deploy Mariadb
podman run --detach \
  --env MYSQL_DATABASE=nextcloud \
  --env MYSQL_USER=nextcloud \
  --env MYSQL_PASSWORD=DB_USER_PASSWORD \
  --env MYSQL_ROOT_PASSWORD=DB_ROOT_PASSWORD \
  --volume nextcloud-db:/var/lib/mysql \
  --network nextcloud-net \
  --restart on-failure \
  --name nextcloud-db \
  docker.io/library/mariadb:10

# Check running containers
podman container ls

# Deploy Nextcloud
podman run --detach \
  --env MYSQL_HOST=nextcloud-db.dns.podman \
  --env MYSQL_DATABASE=nextcloud \
  --env MYSQL_USER=nextcloud \
  --env MYSQL_PASSWORD=DB_USER_PASSWORD \
  --env NEXTCLOUD_ADMIN_USER=NC_ADMIN \
  --env NEXTCLOUD_ADMIN_PASSWORD=NC_PASSWORD \
  --volume nextcloud-app:/var/www/html \
  --volume nextcloud-data:/var/www/html/data \
  --network nextcloud-net \
  --restart on-failure \
  --name nextcloud \
  --publish 8080:80 \
  docker.io/library/nextcloud:20

# Check running containers
podman container ls

### update

# Update mariadb
podman pull mariadb:10
podman stop nextcloud-db
podman rm nextcloud-db
podman run --detach \
  --env MYSQL_DATABASE=nextcloud \
  --env MYSQL_USER=nextcloud \
  --env MYSQL_PASSWORD=DB_USER_PASSWORD \
  --env MYSQL_ROOT_PASSWORD=DB_ROOT_PASSWORD \
  --volume nextcloud-db:/var/lib/mysql \
  --network nextcloud-net \
  --restart on-failure \
  --name nextcloud-db \
  docker.io/library/mariadb:10

# Update Nextcloud
podman pull nextcloud:20
podman stop nextcloud
podman rm nextcloud
podman run --detach \
  --env MYSQL_HOST=nextcloud-db.dns.podman \
  --env MYSQL_DATABASE=nextcloud \
  --env MYSQL_USER=nextcloud \
  --env MYSQL_PASSWORD=DB_USER_PASSWORD \
  --env NEXTCLOUD_ADMIN_USER=NC_ADMIN \
  --env NEXTCLOUD_ADMIN_PASSWORD=NC_PASSWORD \
  --volume nextcloud-app:/var/www/html \
  --volume nextcloud-data:/var/www/html/data \
  --network nextcloud-net \
  --restart on-failure \
  --name nextcloud \
  --publish 8080:80 \
  docker.io/library/nextcloud:20

