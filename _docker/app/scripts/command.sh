#!/bin/bash

cd /src;

export VENV_DIR="/src/.cache/.virtualenv";

command="serve"

if [ ! -d "$VENV_DIR" ]; then
    python -m venv $VENV_DIR;
fi

source $VENV_DIR/bin/activate;

if [ $# -gt 0 ]; then command=$1; fi

if [ "$command" == "exec" ]; then
    shift; $@;

elif [ "$command" == "serve" ]; then
    port=8000; if [ $# -gt 1 ]; then port=$2; fi
    cd backend;
    python3 manage.py runserver "0.0.0.0:$port"

elif [ "$command" == "status" ]; then

    supervisorctl status;

elif [[ "start stop restart" =~ "$command" ]]; then

    service="all"; if [ $# -gt 1 ]; then shift; service=$@; fi
    supervisorctl $command $service;

else
    cd backend;
    python3 manage.py $@
fi