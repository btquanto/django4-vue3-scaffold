#!/bin/bash

# cd into the script's directory
# This allows calling the script from anywhere
dir_path=$(dirname $(realpath $0))
cd $dir_path;

project=`basename "$(pwd)"`;
env_docker="config/.env_docker";
source scripts/utilities.sh;

if (( $# > 0 )); then app=$1; fi

if [[ -z $app ]] || [[ ! "yarn app node docker init" =~ $app ]]; then
  print_help;
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
  elif [[ $command == "pip-install" ]]; then
    dkrcmp exec app sh /src/scripts/apt-install.sh gettext;
    if [[ -z "$args" ]]; then
      dkrcmp exec app pip3 install -r requirements.txt;
    else
      dkrcmp exec app pip3 install $args
    fi
  elif [[ $command == "install" ]]; then
    dkrcmp exec app sh /src/scripts/apt-install.sh $args;
  else
    dkrcmp exec app cmd $command $args;
  fi
fi

if [[ $app == "node" ]]; then
  if [[ $command == "install" ]]; then
    dkrcmp exec node sh /src/scripts/apk-install.sh $args;
  else
    dkrcmp exec node $command $args;
  fi
fi

if [[ $app == "yarn" ]]; then
    dkrcmp exec node sh /src/scripts/apk-install.sh git;
    if [[ $command == "install" ]]; then
      dkrcmp exec node sh /src/scripts/apk-install.sh git;
    fi
    dkrcmp exec node yarn $command $args;
fi
