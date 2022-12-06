# Ensure that dist folder exists
mkdir -p dist;

if [[ $APP == "node" ]]; then
  dkrcmp exec $([[ "$MODE" == "root" ]] && echo 0 || id -u) node $COMMAND "${ARGS[@]}";
fi

if [[ $APP == "yarn" ]]; then
  dkrcmp exec --user $(id -u) node yarn "$COMMAND" "${ARGS[@]}";
fi
