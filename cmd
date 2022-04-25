#!/bin/bash

BASH_SOURCE=".$0";

# Do not allow sourcing this script
if [[ ".$0" == ".$BASH_SOURCE" ]]; then
  # cd into the script's directory
  # This allows calling the script from anywhere
  project_root_path=$(dirname $(realpath $0));
  cd $project_root_path;
  project=`basename "$(pwd)"`;
  env_docker="config/.env_docker";
 
  app_deps="$(cat packages-app.txt | tr -s '\n' ' ')"
  node_deps="$(cat packages-node.txt | tr -s '\n' ' ')"

  source scripts/utilities.sh;

  if [ $# -gt 0 ]; then app=$1; fi

  if [[ -z $app ]] || [[ ! "yarn app node docker init" =~ $app ]]; then
    cat documents/help_content.md;
    exit 0;
  fi

  command=""
  if [ $# -gt 1 ]; then command=$2; fi;

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
    if [[ $command == "pip-install" ]]; then
      if [[ -z "$args" ]]; then
        dkrcmp exec app bash /src/scripts/pip-install.sh;
      else
        dkrcmp exec app bash /src/scripts/pip-install.sh $args;
      fi
    elif [[ $command == "install" ]]; then
      U_ID="$(id -u root)";
      G_ID="$(id -g root)";
      if [[ -z "$args" ]] && [[ ! -z $app_deps ]]; then
        U_ID=$U_ID G_ID=$G_ID dkrcmp exec --user $U_ID app bash /src/scripts/apt-install.sh $app_deps;
      elif [[ ! -z "$args" ]]; then
        U_ID=$U_ID G_ID=$G_ID dkrcmp exec --user $U_ID app bash /src/scripts/apt-install.sh $args;
      fi
    else
      dkrcmp exec app cmd $command $args;
    fi
  fi

  if [[ $app == "node" ]]; then
    if [[ $command == "install" ]]; then
      U_ID="$(id -u root)";
      G_ID="$(id -g root)";
      if [[ -z "$args" ]] && [[ ! -z $app_deps ]]; then
        U_ID=$U_ID G_ID=$G_ID dkrcmp exec --user $U_ID node sh /src/scripts/apk-install.sh $node_deps;
      elif [[ ! -z "$args" ]]; then
        U_ID=$U_ID G_ID=$G_ID dkrcmp exec --user $U_ID node sh /src/scripts/apk-install.sh $args;
      fi
    else
      dkrcmp exec node $command $args;
    fi
  fi

  if [[ $app == "yarn" ]]; then
      if [[ $command == "install" && ! -z $node_deps ]]; then
        U_ID="$(id -u root)";
        G_ID="$(id -g root)";
        U_ID=$U_ID G_ID=$G_ID dkrcmp exec --user $U_ID node sh /src/scripts/apk-install.sh $node_deps;
      fi
      dkrcmp exec node yarn $command $args;
  fi
else
  echo "Sourcing this script is not allowed";
fi