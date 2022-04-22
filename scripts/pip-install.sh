#!/bin/bash

export HOME="/src/.cache/home";
export WHEELDIR="/src/.cache/.wheel";
export REQUIREMENTS="requirements.txt";
export PIP_CACHE_DIR="/src/.cache/.pip";

set -u;
cd /src

[ ! -d $HOME ] || mkdir -p $HOME;
[ ! -d $PIP_CACHE_DIR ] || mkdir -p $PIP_CACHE_DIR;

export PATH=/src/.cache/home/.local/bin:$PATH;

if [ ! -d ".venv" ]; then
    python -m venv .venv;
fi

source .venv/bin/activate;

if [ $# -gt 0 ]; then
  pip install $@;
else
  pip wheel --find-links=$WHEELDIR -w $WHEELDIR -r $REQUIREMENTS;
  pip install --no-index --find-links=$WHEELDIR -r $REQUIREMENTS;
fi