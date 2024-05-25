
#!/bin/bash
set -ex

# This file is called in three scenarios:
# 1. fresh creation of devcontainer
# 2. rebuild
# 3. full rebuild

# ddev default commands
# see: https://ddev.readthedocs.io/en/latest/users/install/ddev-installation/#github-codespaces

# retry, see https://github.com/ddev/ddev/pull/5592
wait_for_docker() {
  while true; do
    docker ps > /dev/null 2>&1 && break
    sleep 1
  done
  echo "Docker is ready."
}

wait_for_docker

# TODO: remove, might not be needed (auto-detected)
# https://github.com/ddev/ddev/pull/5290#issuecomment-1689024764
ddev config global --omit-containers=ddev-router

# download images beforehand
ddev debug download-images

# avoid errors on rebuilds
ddev poweroff

# Workaround for Vite:
# Normally expose port 5173 for Vite in .ddev/config.yaml, but ddev-router
# is not used  on Gitpod / Codespaces, etc. The Routing is handled by Gitpod /
# Codespaces itself. Therefore we will create an additional config file for
# DDEV which will expose port 5173 without ddev-router.
cp .devcontainer/templates/docker-compose.vite-workaround.yaml .ddev/.

# Start the DDEV project
# (will automatically get URL from env, adds db connection to .env)
export DDEV_NONINTERACTIVE=true
ddev start -y

# Start the DDEV project
# (will automatically get URL from env, adds db connection to .env)
export DDEV_NONINTERACTIVE=true
ddev start -y

# Prepare Laravel website
ddev composer install
ddev npm install
ddev artisan key:generate
ddev artisan migrate

# Further steps - you could also import a database here:
# ddev import-db --file=dump.sql.gz
# or use 'ddev pull' to get latest db / files from remote
# https://ddev.readthedocs.io/en/stable/users/providers/

