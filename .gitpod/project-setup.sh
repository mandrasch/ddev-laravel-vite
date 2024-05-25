#!/usr/bin/env bash

# Prepare vscode-xdebug setup
mkdir -p .vscode
cp .gitpod/templates/launch.json .vscode/.

# Workaround for vite:
# Normally expose port 5173 for Vite in .ddev/config.yaml, but ddev-router is not used  on Gitpod. The 
# Routing is handled by Gitpod itself. Therefore we will create an additional config file for DDEV 
# which will expose port 5173 without ddev-router.
cp .gitpod/templates/docker-compose.vite-workaround.yaml .ddev/.

# Set up ddev project for Gitpod
export DDEV_NONINTERACTIVE=true
ddev start -y

# Prepare Laravel website
ddev composer install
ddev npm install
ddev artisan key:generate
ddev artisan migrate