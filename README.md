# First words

This guide assumes you are using a Linux/Mac OS system. The commands can be different on Windows. Please adapt accordingly.

Please ensure that you already have `docker` and `docker-compose` installed.

## The `./cmd` script

This script contains shortcuts for a lot of operations. You should first read its [help menu](documents/help_content.md) for a rough understanding of what it does.

# Initialize the project and setting environment variables

Initialize project's configuration files

    ./cmd init

Edit `config/.env_docker`, `config/.env_django` and `backend/config/local.py` as fit.

## AUTO_START

The configuration `AUTO_START` will be used in `supervisor` configuration. This controls whether or not the supervisord service `asgi` will be started when the container starts. Set this to `true` for production.

# Before first run

## Start docker containers

    ./cmd docker up

## Install front-end dependencies

    ./cmd yarn install

## Install back-end dependencies

    ./cmd app install

# Running application 

## Build front-end

    # Build for development
    ./cmd yarn dev

    # Build for production
    ./cmd yarn build

    # Build for development and watch for changes
    ./cmd yarn serve

## Start back-end

## Start docker (if it's not already started)

    ./cmd docker up

## View docker log

    ./cmd docker logs

# Running migrations

    ./cmd app migrate

## Start back-end server in debug mode

    ./cmd app serve

## Start/Stop/Restart back-end server using supervisor

    ./cmd app start/stop/restart asgi

## Check supervisor service status

    ./cmd app status # All services
    ./cmd app status asgi # Specific services

## Access on browser

After everything, you can access the page at `localhost:7500`
