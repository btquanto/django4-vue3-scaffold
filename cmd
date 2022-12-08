#!/bin/bash

BASH_SOURCE=".$0";

# Do not allow sourcing this script
if [[ ".$0" != ".$BASH_SOURCE" ]]; then
  echo "Sourcing this script is not allowed";
  return;
fi

function setup_env() {
  # cd into the script's directory
  # This allows calling the script from anywhere
  ROOT_PATH=$(dirname $(realpath $0));
  cd $ROOT_PATH;

  # Global variables
  [ -z ${MODE+x} ] && ([ ! -z ${ROOT+x} ] || [ ! -z ${root+x} ]) && MODE="root"
  PROJECT=`basename "$(pwd)" | tr '[:upper:]' '[:lower:]'`;
  ENV_DOCKER="config/.docker";

  [ $# -gt 0 ] && APP=$1;
  [ $# -gt 1 ] && COMMAND=$2 || COMMAND="";

  shift 2;
  ARGS=()
  for arg in "$@"; do
    ARGS+=("$arg")
  done
}

setup_env "$@";

if [[ -z $APP ]] || [[ ! "yarn app node docker init" =~ "$APP" ]]; then
  cat _documents/help_content.md;
  exit 0;
fi

function init() {
  if [ ! -f "config/.docker" ]; then
    printf "Docker environment file (config/.docker) not found. Generating...\n";
    cp config/_docker config/.docker;
    printf "'config/.docker' is added to your project. You may want to update this file manually.\n\n"
  fi

  source "config/.docker";

  if [ ! -z "$DJANGO_CONFIG_MODULE" ]; then
      CONFIG_FILE="backend/${DJANGO_CONFIG_MODULE//\.//}.py";
  else
      CONFIG_FILE="backend/config/local.py"
  fi

  if [ ! -f "config/.django" ]; then
      printf "Django environment file (config/.django) not found. Generating...\n";
      cp config/_django config/.django;
      printf "'config/.django' is added to your project. You may want to update this file manually.\n\n"
  fi

  if [ ! -f $CONFIG_FILE ]; then
      printf "Django local configuration file ('$CONFIG_FILE') not found. Generating...\n"
      cp backend/config/config.py.template $CONFIG_FILE;
      printf "'$CONFIG_FILE' is added to your project. You may want to update this file manually.\n\n"
  fi
}

if [[ $APP == "init" ]]; then init; fi

function dkrcmp() {
  echo "docker compose --env-file $ENV_DOCKER \\
                -p $PROJECT $@;";
  docker compose --env-file $ENV_DOCKER -p $PROJECT "$@";
}

if [ $APP = "docker" ]; then
  if [ "$COMMAND" = "up" ]; then
    [ -z "${ARGS[@]}" ] && ARGS=(-d);
    [ "${ARGS[@]}" = "--fg" ] && ARGS=();
  fi
  if [ "$COMMAND" = "logs" ]; then
    [ -z "${ARGS[@]}" ] && ARGS=(app);
    [ ${#ARGS[@]} -eq 1 ] && ARGS=("-f" "${ARGS[@]}");
  fi
  if [ "$COMMAND" = "build" ]; then
      echo "USER_ID=${USER_ID:-$(id -u)} docker compose --env-file $ENV_DOCKER build;";
      USER_ID=${USER_ID:-$(id -u)} docker compose --env-file "$ENV_DOCKER" build;
  else
    dkrcmp $COMMAND "${ARGS[@]}";
  fi
fi

if [[ $APP == "app" ]]; then
  if [[ "serve migrate makemigrations start stop restart status" =~ "$COMMAND" ]]; then
    if [[ "start stop restart status" =~ "$COMMAND" ]]; then
      MODE="root";
    fi
    dkrcmp exec --user $([[ "$MODE" == "root" ]] && echo 0 || id -u) app cmd $COMMAND "${ARGS[@]}";
  elif [[ "$COMMAND" == "install" ]]; then
    dkrcmp exec --user $(id -u) app bash pip-install "${ARGS[@]}";
  else
    dkrcmp exec --user $([[ "$MODE" == "root" ]] && echo 0 || id -u) app $COMMAND "${ARGS[@]}";
  fi
fi

mkdir -p dist;

if [[ $APP == "node" ]]; then
  dkrcmp exec --user $([[ "$MODE" == "root" ]] && echo 0 || id -u) node $COMMAND "${ARGS[@]}";
fi

if [[ $APP == "yarn" ]]; then
  dkrcmp exec --user $(id -u) node yarn "$COMMAND" "${ARGS[@]}";
fi
