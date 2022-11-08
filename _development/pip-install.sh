#!/bin/bash

export HOME="/src/.cache/home";
export PIP_CACHE_DIR="/src/.cache/.pip";
export WHEELDIR="/src/.cache/.wheel";
export VENV_DIR="/src/.cache/.virtualenv";
export REQUIREMENTS="requirements.txt";

set -u;
cd /src

[ ! -d $HOME ] || mkdir -p $HOME;
[ ! -d $PIP_CACHE_DIR ] || mkdir -p $PIP_CACHE_DIR;

export PATH=/src/.cache/home/.local/bin:$PATH;

if [ ! -d $VENV_DIR ]; then
    python -m venv $VENV_DIR;
fi

source $VENV_DIR/bin/activate;

if [ $# -gt 0 ]; then
  pip install $@;
else
  pip wheel --find-links=$WHEELDIR -w $WHEELDIR -r $REQUIREMENTS;
  pip install --no-index --find-links=$WHEELDIR -r $REQUIREMENTS;
fi