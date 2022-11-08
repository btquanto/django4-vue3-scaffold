#!/bin/bash
export HOME="/src/.cache/home";
export REQUIREMENTS="requirements.txt";
export PIP_CACHE_DIR="/src/.cache/.pip";
export VENV_DIR="/src/.cache/.virtualenv";

set -u;
cd /src;

if [ ! -d $HOME ]; then mkdir -p $HOME; fi;
if [ ! -d $PIP_CACHE_DIR ]; then mkdir -p $PIP_CACHE_DIR; fi;

export PATH=/src/.cache/home/.local/bin:$PATH;

# Checking apps dependencies
echo "Server starting..."

if [ ! -d $VENV_DIR ]; then
    python -m venv $VENV_DIR;
fi

source $VENV_DIR/bin/activate;

read -r -d '' CODE << EOM
import pkg_resources

dependencies = [ 'wheel' ]
try:
    pkg_resources.require(dependencies)
    exit(0)
except Exception as ex:
    import traceback
    print(ex)
    exit(1)
EOM

python3 -c "$CODE"

if [ ! $? -eq 0 ]; then
    echo "Installing wheel";
    bash _development/pip-install.sh wheel;
fi

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
        bash _development/pip-install.sh -U pip;
        # Install requirements
        bash _development/pip-install.sh;
        echo "All dependencies are installed";
    fi;
fi

# Services
supervisord;

echo "Server started...";
sleep infinity;
