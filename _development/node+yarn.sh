# Ensure that dist folder exists
mkdir -p dist;

if [[ $APP == "node" ]]; then
  if [[ $MODE == "root" ]]; then
    dkrcmp exec node $COMMAND $ARGS;
  else
    dkrcmp exec --user $(id -u) node $COMMAND $ARGS;
  fi
fi

if [[ $APP == "yarn" ]]; then
  dkrcmp exec --user $(id -u) node yarn $COMMAND $ARGS;
fi
