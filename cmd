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
  PROJECT=`basename "$(pwd)" | tr '[:upper:]' '[:lower:]'`;
  ENV_DOCKER="config/.docker";
  APP_DEPENDENCIES="$(cat packages-app.txt | tr -s '\n' ' ')"
  NODE_DEPENDENCIES="$(cat packages-node.txt | tr -s '\n' ' ')"

  if [ $# -gt 0 ]; then APP=$1; fi
  COMMAND=""
  if [ $# -gt 1 ]; then COMMAND=$2; fi;

  shift 2;
  ARGS=""
  for arg in "$@"; do
      arg="${arg//\\/\\\\}"
      if [[ $arg == *" "* ]]; then
        ARGS="$ARGS \"${arg//\"/\\\"}\""
      else
        ARGS="$ARGS ${arg//\"/\\\"}"
      fi
  done
}

setup_env "$@";

source _development/help.sh;
source _development/init.sh;
source _development/docker.sh;
source _development/app.sh;
source _development/node+yarn.sh;
