#!/usr/bin/env bash

# Prepare vscode-xdebug setup
mkdir -p .vscode
cp .gitpod/templates/launch.json .vscode/.

# Prepare Laravel website
ddev composer install
ddev npm install
ddev artisan key:generate
ddev artisan migrate