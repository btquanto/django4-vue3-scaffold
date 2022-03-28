# First words

This guide assumes you are using a Linux/Mac OS system. The commands can be different on Windows. Please adapt accordingly.

Please ensure that you already have `docker` and `docker-compose` installed.

## The `./cmd` script

This script contains shortcuts for a lot of operations. You should first read its help menu for a rough understanding of what it does.

```
    Help: ./cmd [init|app|yarn|docker] <command> <arguments>

    # 'init' module

    ./cmd init

    Inititialize the project. This will generate local configuration files necessary to run the project.
    Basically, we would run this once at the beginning of the project.

    # 'app' module

    ./cmd app <command> <arguments>

    ## Example

        ./cmd app install -U pip # Upgrade pip requirements

    ## Commands

        install <arguments>:
        Calling 'pip3 install <arguments>'.
        If no <arguments> is provided, default to calling 'pip3 install -r requirements.txt'
        
        exec    : exec the command specified in <arguments>
        
        serve <port>  : Run the application in debug mode.
                        If no port is specified, it will default to port 8000

        [start|stop|restart|status] <supervisor service> : 
                Start/Stop/Restart/Checking Status supervisor services.
                If no services are specified, all services are selected.

        [migrate|makemigrations|showmigrations|makemessages|compilemessages|...] <arguments> :
                django_admin commands.


    # 'yarn' module

    ./cmd yarn <command> <arguments>

    Calling yarn commands

    ## Commands

        serve   : Serve front-end in development mode and watch for changes
        dev     : Build front-end in development mode
        build   : Build front-end in production mode
        lint    : Run linting


    # 'node' module

    ./cmd node <command> <arguments>

    Executing commands in node container

    ## Commands

        install   : Calling 'apk --no-cache add <arguments>'
                    If no <arguments> are specified, install 'git ssh'
    
    # 'docker' module

    ./cmd docker <command> <arguments>

    Shortcut for calling 
    
        docker-compose --env-file /path/to/env/file -p <project_name> <command> <arguments>

```

# Initialize the project and setting environment variables

Initialize project's configuration files

    ./cmd init

Edit `config/.env_docker`, `config/.env` and `backend/config/local.py` as fit.

## AUTO_START

The configuration `AUTO_START` will be used in `supervisor` configuration. This controls whether or not the supervisord service `asgi` will be started when the container starts. Set this to `true` for production.

# Before first run

## Start docker containers

    ./cmd docker up

## Install front-end dependencies

    ./cmd node install
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