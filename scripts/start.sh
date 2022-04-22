#!/bin/bash
export HOME="/src/.cache/home";
export REQUIREMENTS="requirements.txt";
export PIP_CACHE_DIR="/src/.cache/.pip";

set -u;
cd /src

[ ! -d $HOME ] || mkdir -p $HOME;
[ ! -d $PIP_CACHE_DIR ] || mkdir -p $PIP_CACHE_DIR;

export PATH=/src/.cache/home/.local/bin:$PATH;

# Checking apps dependencies
echo "Server starting..."

if [ ! -d ".venv" ]; then
    python -m venv .venv;
fi

. .venv/bin/activate;

read -r -d '' CODE << EOM
import pkg_resources

with open('requirements.txt', 'r') as fp:
    dependencies = fp.readlines()
try:
    pkg_resources.require(dependencies)
    exit(0)
except Exception as ex:
    import traceback
    print(ex)
    exit(1)
EOM

python3 -c "$CODE"

if [ $? -eq 0 ]; then
    echo "All dependencies from 'requirements.txt' are met";
else
    if [ -f $REQUIREMENTS ]; then
        echo "Installing missing dependencies";
        # Upgrade pip
        pip3 install -U pip;
        # Install requirements
        pip3 install -r $REQUIREMENTS;
        echo "All dependencies are installed";
    fi;
fi

# Services
supervisord

echo "Server started..."
sleep infinity;