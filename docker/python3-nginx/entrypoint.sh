#!/bin/bash
set -eu;

if [ $# -eq 0 ]; then
    nginx -g "daemon off;";
else
    exec "$@";
fi