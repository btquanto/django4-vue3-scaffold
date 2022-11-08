# Ensure that dist folder exists
mkdir -p dist;

if [[ $APP == "node" ]]; then
  if [[ $COMMAND == "install" ]]; then
    U_ID="$(id -u root)";
    G_ID="$(id -g root)";
    if [[ -z "$ARGS" ]] && [[ ! -z "$APP_DEPENDENCIES" ]]; then
      U_ID=$U_ID G_ID=$G_ID dkrcmp exec --user $U_ID node sh /src/_development/apk-install.sh "$NODE_DEPENDENCIES";
    elif [[ ! -z "$ARGS" ]]; then
      U_ID=$U_ID G_ID=$G_ID dkrcmp exec --user $U_ID node sh /src/_development/apk-install.sh "$ARGS";
    fi
  else
    if [[ $MODE == "root" ]]; then
      dkrcmp exec --user 0 node $COMMAND $ARGS;
    else
      dkrcmp exec node $COMMAND $ARGS;
    fi
  fi
fi

if [[ $APP == "yarn" ]]; then
  if [[ $COMMAND == "install" && ! -z "$NODE_DEPENDENCIES" ]]; then
    U_ID="$(id -u root)";
    G_ID="$(id -g root)";
    U_ID=$U_ID G_ID=$G_ID dkrcmp exec --user $U_ID node sh /src/_development/apk-install.sh "$NODE_DEPENDENCIES";
  fi
  dkrcmp exec node yarn $COMMAND $ARGS;
fi
