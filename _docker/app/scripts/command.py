#!/usr/bin/env python3
import sys
from subprocess import call as subprocess_call

ARGS = sys.argv[1:]
ARGS = [arg if len(arg.split()) == 1 else f'"{arg}"' for arg in ARGS]


COMMAND = ARGS[0] if len(ARGS) > 0 else None
ARGS = ARGS[1:]

if __name__ == "__main__":
    PYTHON = "/src/.cache/.virtualenv/bin/python3"
    if COMMAND == "serve":
        PORT = 8000
        if ARGS:
            PORT = ARGS[0]
        print(f'{PYTHON} manage.py runserver "0.0.0.0:{PORT}"')
        subprocess_call(f'{PYTHON} manage.py runserver "0.0.0.0:{PORT}"', shell=True, cwd="/src/backend/")
    elif COMMAND in ["start", "stop", "restart"]:
        SERVICES = "all"
        if ARGS:
            SERVICES = " ".join(ARGS)
        subprocess_call(f"supervisorctl {COMMAND} {SERVICES}", shell=True)
    else:
        print(f"{PYTHON} manage.py {COMMAND} {' '.join(ARGS)}")
        subprocess_call(f"{PYTHON} manage.py {COMMAND} {' '.join(ARGS)}", shell=True, cwd="/src/backend/")
