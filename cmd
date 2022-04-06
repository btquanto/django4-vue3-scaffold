#!/bin/bash

# cd into the script's directory
# This allows calling the script from anywhere
dir_path=$(dirname $(realpath $0))
cd $dir_path;

project=`basename "$(pwd)"`;
env_docker="config/.env_docker";
source scripts/utilities.sh;

read -r -d '' help <<-EOF
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

if (( $# > 0 )); then app=$1; fi

if [[ -z $app ]] || [[ ! "yarn app node docker init" =~ $app ]]; then
  printf "$help\n";
  exit 0;
fi

command=""
if (($# > 1)); then command=$2; fi;

shift 2;

args=""
for arg in "$@"; do
    arg="${arg//\\/\\\\}"
    if [[ $arg == *" "* ]]; then
      args="$args \"${arg//\"/\\\"}\""
    else
      args="$args ${arg//\"/\\\"}"
    fi
done

if [[ $app == "init" ]]; then init; fi

if [[ $app == "docker" ]]; then
  if [[ $command == "up" && -z "$args" ]]; then
    args="-d";
  fi
  if [[ $command == "logs" && -z "$args" ]]; then
    args="-f app";
  fi
  dkrcmp $command $args;
fi

if [[ $app == "app" ]]; then
  if [[ "start stop restart status" =~ "$command"  && -z "$args" ]]; then 
    args="all";
  fi
  if [[ $command == "exec" ]]; then
    dkrcmp exec app $args;
  elif [[ $command == "install" ]]; then
    if [[ -z "$args" ]]; then
      dkrcmp exec app pip3 install -r requirements.txt;

    else
      dkrcmp exec app pip3 $command $args
    fi
  else
    dkrcmp exec app cmd $command $args;
  fi
fi

if [[ $app == "node" ]]; then
  if [[ $command == "install" ]]; then
      if [[ -z "$args" ]]; then
        dkrcmp exec node apk --no-cache add git;
      else
        dkrcmp exec node apk --no-cache add $args;
      fi
  else
    dkrcmp exec node $command $args;
  fi
fi

if [[ $app == "yarn" ]]; then
    dkrcmp exec node yarn $args;
fi
