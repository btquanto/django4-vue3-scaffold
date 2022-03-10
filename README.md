# Setting up the project

This guide assumes you are using a Linux/Mac OS system. The commands can be different on Windows. Please adapt accordingly.

Please ensure that you already have `docker` and `docker-compose` installed.


# Setting the environment

Create a local configuration for generating `docker-compose.yml`.

    cp config/_env_docker config/.env_docker

You will need to edit `config/.env_docker` as fit. Please check `config/_docker-compose.yml` for more details.

## AUTO_START

The configuration `AUTO_START` will be used in `supervisor` configuration. This controls whether or not the supervisord service `asgi` will be started when the container starts. Set this to `true` for production.

## Docker Compose and Django local configuration

After editing `config/.env_docker`, you will need to generate the `docker-compose.yml` file.

    ./cmd init

This will also create two new environment files: `config/.env` and `backend/config/local.py`. They are local configurations for Django. Please edit them as fit.

# Install front-end dependencies

    ./cmd install node

There may be errors happens. This has only been tested on `node v14.x.x`. If you are using a different version, switch to `node v14.x.x`, or try to fix it yourself.

# Build front-end

    # Just build
    ./cmd build

    # Just build, but for production mode
    ./cmd build prod

    # Build and watch for changes
    ./cmd watch

# Start back-end

## Start docker

    docker-compose up -d

## View docker log

    ./cmd logs


# Running migrations

    ./cmd migrate

## Start server in debug mode

    ./cmd serve

## Start/Stop/Restart server using supervisor

    ./cmd start/stop/restart asgi

## Check supervisor service status

    ./cmd status # All services
    ./cmd status asgi nginx # Some services
