#!/usr/bin/env bash

# Prepare vscode-xdebug setup
mkdir -p .vscode
cp .gitpod/templates/launch.json .vscode/.

# Workaround for Vite:
# Normally expose port 5173 for Vite in .ddev/config.yaml, but ddev-router
# is not used  on Gitpod / Codespaces, etc. The Routing is handled by Gitpod /
# Codespaces itself. Therefore we will create an additional config file for
# DDEV which will expose port 5173 without ddev-router.
cp .gitpod/templates/docker-compose.vite-workaround.yaml .ddev/.

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
