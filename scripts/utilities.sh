function dkrcmp() {
  if [ -z U_ID ]; then USER_ID="$(id -u)"; fi;
  if [ -z G_ID ]; then USER_ID="$(id -g)"; fi;

  DOCKER_USER="$U_ID:$G_ID";
  echo "DOCKER_USER=$DOCKER_USER docker-compose --env-file $env_docker -p $project $@;";
  DOCKER_USER=$DOCKER_USER docker-compose --env-file $env_docker -p $project $@;
}

function build() {
  if [[ "$1" == 'dev' ]]; then
    dkrcmp exec node yarn $@;
  elif [[ "$1" == 'watch' ]]; then
    dkrcmp exec node yarn dev --watch;
  else
    dkrcmp exec node yarn build;
  fi
}

function init() {

  if [ -f "config/.env_docker" ]; then
      source "config/.env_docker";
  else
      echo "Docker environment file (config/.env_docker) not found.";
      echo "Please create a 'config/.env_docker' from the template 'config/_env_docker'.";
      echo "Quick command: cp config/_env_docker config/.env_docker";
      exit 1;
  fi

  if [ ! -z "$DJANGO_CONFIG_MODULE" ]; then
      CONFIG_FILE="backend/${DJANGO_CONFIG_MODULE//\.//}.py";
  else
      CONFIG_FILE="backend/config/local.py"
  fi

  if [ ! -f "config/.env" ]; then
      echo "'config/.env' not found. Generating...";
      cp config/_env config/.env;
      echo "'config/.env' is added to your project. You may want to update this file manually."
  fi

  if [ ! -f $CONFIG_FILE ]; then
      echo "'$CONFIG_FILE' not found. Generating..."
      cp backend/config/config.py.template $CONFIG_FILE;
      echo "'$CONFIG_FILE' is added to your project. You may want to update this file manually."
  fi
}

function print_help() {
  read -r -d '' help_content <<-EOF
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

EOF
  printf "$help_content\n";
}