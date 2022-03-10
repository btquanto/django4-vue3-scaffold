#!/bin/bash

cd /src;

command="serve"

if [ $# -gt 0 ]; then command=$1; fi

if [ "$command" == "serve" ]; then

    port=8000; if [ $# -gt 1 ]; then port=$2; fi
    cd backend;
    python3 manage.py runserver "0.0.0.0:$port"

elif [ "$command" == "renew-ssl" ]; then

    mkdir -p /etc/nginx/ssl;

    if [ ! -f /etc/nginx/ssl/server.key ]; then
        # RSA key
        openssl genrsa -out /etc/nginx/ssl/server.key 2048;
    fi

    if [ ! -f /etc/nginx/ssl/server.csr ]; then
        # Certificate signing request
        openssl req -new -key /etc/nginx/ssl/server.key -subj "/C=JP/ST=Tokyo/L=Shinjuku/O=PrimeStyle/CN=localhost" -out /etc/nginx/ssl/server.csr;
    fi

    # SSL certificate
    openssl x509 -req -in /etc/nginx/ssl/server.csr -days 1800 -signkey /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt;

elif [ "$command" == "status" ]; then

    supervisorctl status;

elif [[ "start stop restart" =~ "$command" ]]; then

    service="all"; if [ $# -gt 1 ]; then shift; service=$@; fi
    supervisorctl $command $service;

else
    cd backend;
    python3 manage.py $@
fi