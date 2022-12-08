
    Help: ./cmd [init|app|yarn|docker] <command> <arguments>

# `init` module

    ./cmd init

  Inititialize the project. This will generate local configuration files necessary to run the project.
  Basically, we would run this once at the beginning of the project.

# `app` module

    ./cmd app <command> <arguments>

  ## Example

    ./cmd app bash # Open a bash shell in the app container

  ## Commands

    install <arguments>

  Calling `pip3 install <arguments>`.
  If no <arguments> is provided, default to calling `pip3 install -r requirements.txt`.

  exec the command specified in `<arguments>`

    serve <port>

  Run the application in debug mode.
  If no port is specified, it will default to port 8000

    [start|stop|restart|status] <supervisor service>

  Start/Stop/Restart/Checking Status supervisor services.
  If no services are specified, all services are selected.

    [migrate|makemigrations] <arguments>

  Common `django_admin` commands.

# `yarn` module

    ./cmd yarn <command> <arguments>

  Calling yarn commands

  ## Yarn commands

    serve

  Serve front-end in development mode and watch for changes

    dev

  Build front-end in development mode

    build

  Build front-end in production mode

    lint

  Run linting


# `node` module

    ./cmd node <command> <arguments>

  Executing bash commands in node container


# `docker` module

  ./cmd docker <command> <arguments>

  Shortcut for calling

    docker-compose --env-file /path/to/env/file -p <project_name> <command> <arguments>

  ## Docker commands

    ./cmd docker build

  Build or rebuild docker images

    ./cmd docker up

  Start docker containers

    ./cmd docker down

  Destroy docker containers

    ./cmd docker logs <service>

  View docker logs for `<service>`. If no `<service>` is provided, default to `app`.

    ./cmd docker
