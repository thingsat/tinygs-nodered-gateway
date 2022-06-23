#!/bin/bash
nvm use stable
node node_modules/node-red/red.js -s ./settings.js -u . --title "tinygs-nodered-gateway"
