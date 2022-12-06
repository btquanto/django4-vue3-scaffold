# Ensure that dist folder exists
mkdir -p dist;

if [[ $APP == "node" ]]; then
  if [[ $MODE == "root" ]]; then
    if [ -z "$ARGS" ]; then
      dkrcmp exec node "$COMMAND";
    else
      dkrcmp exec node "$COMMAND" "$ARGS";
    fi
  else
    if [ -z "$ARGS" ]; then
      dkrcmp exec --user $(id -u) node "$COMMAND";
    else
      dkrcmp exec --user $(id -u) node "$COMMAND" "$ARGS";
    fi
  fi
fi

if [[ $APP == "yarn" ]]; then
  if [ -z "$ARGS" ]; then
    dkrcmp exec --user $(id -u) node yarn "$COMMAND";
  else
    dkrcmp exec --user $(id -u) node yarn "$COMMAND" "$ARGS";
  fi
fi
