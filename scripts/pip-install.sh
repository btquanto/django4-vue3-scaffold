#!/bin/bash

export HOME="/src/.cache/home";
export REQUIREMENTS="requirements.txt";
export PIP_CACHE_DIR="/src/.cache/.pip";

set -u;
cd /src

[ ! -d $HOME ] || mkdir -p $HOME;
[ ! -d $PIP_CACHE_DIR ] || mkdir -p $PIP_CACHE_DIR;

export PATH=/src/.cache/home/.local/bin:$PATH;

echo "$HOME";
echo "$REQUIREMENTS";
echo "$PATH";
echo "$PIP_CACHE_DIR";

if [ ! -d ".venv" ]; then
    python -m venv .venv;
fi

source .venv/bin/activate;

if [ $# -gt 0 ]; then
  pip install -U "$@";
else
  pip install -r $REQUIREMENTS;
fi