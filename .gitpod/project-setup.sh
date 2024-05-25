#!/usr/bin/env bash

# Prepare vscode-xdebug setup
mkdir -p .vscode
cp .gitpod/templates/launch.json .vscode/.

# Prepare Laravel website
export DDEV_NONINTERACTIVE=true
ddev start -y
ddev composer install
ddev npm install
ddev artisan key:generate
ddev artisan migrate

# TODO: reset DDEV_NONINTERACTIVE it after finishing?