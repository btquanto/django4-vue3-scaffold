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

source _development/help.sh;
source _development/init.sh;
source _development/docker.sh;
source _development/app.sh;
source _development/node+yarn.sh;
