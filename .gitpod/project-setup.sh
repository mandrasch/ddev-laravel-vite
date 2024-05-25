#!/usr/bin/env bash

# Prepare vscode-xdebug setup
mkdir -p .vscode
cp .gitpod/templates/launch.json .vscode/.

# Set up ddev project for Gitpod
export DDEV_NONINTERACTIVE=true

# Workaround for vite:
# We expose port 5174 for Vite in .ddev/config.yaml, but ddev-router is not used  on Gitpod. The 
# Routing is handled by codespaces itself. Therefore we will create an additional config file for DDEV 
# which will expose port 5174.

if [ ! -f ".ddev/docker-compose.codespaces-vite.yaml" ]; then
    echo "Creating docker compose file to expose Vite port on Gitpod ..."
    # info: this file should not be commited to git since it shouldn't be used on local DDEV
    cat >.ddev/docker-compose.codespaces-vite.yaml <<EOL
services:
  web:
    ports:
    - 5174:5174
EOL
fi

ddev start -y

# Prepare Laravel website
ddev composer install
ddev npm install
ddev artisan key:generate
ddev artisan migrate

# TODO: reset DDEV_NONINTERACTIVE it after finishing?