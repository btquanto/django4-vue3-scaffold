#!/bin/bash

project=`basename "$(pwd)"`;
env_docker="config/.env_docker";
command="";

if [ $# -gt 0 ]; then command=$1; fi

args="";

if [[ "start stop restart status" =~ "$command" ]]; then args="all"
elif [[ "logs" =~ "$command" ]]; then args="app";
elif [[ "build" =~ "$command" ]]; then args="dev";
fi

if [ $# -gt 1 ]; then shift; args=$@; fi;


function dkrcmp() {
  echo "docker-compose --env-file $env_docker -p $project $@";
  docker-compose --env-file $env_docker -p $project $@;
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
  dkrcmp exec node apk --no-cache add git;
  dkrcmp exec node yarn install;
}

if [[ "init" =~ "$command" ]]; then
  init;
elif [[ "up" =~ "$command" ]]; then
  dkrcmp up -d;
elif [[ "docker system dkr sys" =~ "$command" ]]; then
  if [[ $args != "" ]]; then
    dkrcmp $args;
  fi
elif [[ "exec" =~ "$command" ]]; then
  dkrcmp exec app $args;
elif [[ "install" =~ "$command" ]]; then
  if [[ $args == "node" ]]; then
    dkrcmp exec node yarn install;
  else
    dkrcmp exec app pip3 install -r requirements.txt;
  fi
elif [[ "logs" =~ "$command" ]]; then
  dkrcmp logs -f $args;
elif [[ "build" =~ "$command" ]]; then
  build $args;
elif [[ "watch" =~ "$command" ]]; then
  build watch;
elif [[ "deploy" =~ "$command" ]]; then
  if [[ $args != "" ]]; then
    git fetch
    git checkout $args
  fi
  dkrcmp exec app pip3 install -r requirements.txt;
  dkrcmp exec node yarn install;
  dkrcmp exec app cmd migrate;
  dkrcmp restart app;
  build prod;
else
  if [ $# -gt 1 ]; then shift; args=$@; fi;
  dkrcmp exec app cmd $command $args
fi;