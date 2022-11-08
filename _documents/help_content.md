
    Help: ./cmd [init|app|yarn|docker] <command> <arguments>

# `init` module

    ./cmd init

  Inititialize the project. This will generate local configuration files necessary to run the project.
  Basically, we would run this once at the beginning of the project.

# `app` module

    ./cmd app <command> <arguments>

  ## Example

    ./cmd app install -U pip # Upgrade pip requirements

  ## Commands

    pip-install <arguments>

  Calling `pip3 install <arguments>`.
  If no <arguments> is provided, default to calling `pip3 install -r requirements.txt`.

    install <arguments>

  Calling `apt update; apt install -y <arguments>`.
  If no `<arguments>` is provided, default to installing the dependencies specified in `packages-app.txt`.

    exec

  exec the command specified in `<arguments>`

    serve <port>

  Run the application in debug mode.
  If no port is specified, it will default to port 8000

    [start|stop|restart|status] <supervisor service>

  Start/Stop/Restart/Checking Status supervisor services.
  If no services are specified, all services are selected.

    [migrate|makemigrations|showmigrations|makemessages|compilemessages|...] <arguments>

  `django_admin` commands.


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

  Executing commands in node container

  ## Node container commands

    install

  Calling `apk --no-cache add <arguments>`
  If no `<arguments>` are specified, default to install the dependencies specified in `packages-node.txt`

# `docker` module

  ./cmd docker <command> <arguments>

  Shortcut for calling

    DOCKER_USER=$DOCKER_USER docker-compose --env-file /path/to/env/file -p <project_name> <command> <arguments>

  - `DOCKER_USER`: Depends on the `G_ID` and `U_ID` specified in `config/.docker`. Default to `"$(id -u):$(id -g)"`.

