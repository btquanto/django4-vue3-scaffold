if [[ $APP == "app" ]]; then
  if [[ "serve migrate makemigrations start stop restart status" =~ "$COMMAND" ]]; then
    if [[ "start stop restart status" =~ "$COMMAND"  && -z "$ARGS" ]]; then
      ARGS="all";
    fi
    dkrcmp exec app cmd $COMMAND $ARGS;
  elif [[ $COMMAND == "pip-install" ]]; then
    dkrcmp exec app bash /src/_development/pip-install.sh "$ARGS";
  elif [[ $command == "install" ]]; then
    U_ID="$(id -u root)";
    G_ID="$(id -g root)";
    if [[ -z "$ARGS" ]] && [[ ! -z "$APP_DEPENDENCIES" ]]; then
      U_ID=$U_ID G_ID=$G_ID dkrcmp exec --user $U_ID app bash /src/_development/apt-install.sh $app_deps;
    elif [[ ! -z "$args" ]]; then
      U_ID=$U_ID G_ID=$G_ID dkrcmp exec --user $U_ID app bash /src/_development/apt-install.sh $args;
    fi
  else
    if [[ $MODE == "root" ]]; then
      dkrcmp exec --user 0 app $COMMAND $ARGS;
    else
      dkrcmp exec app $COMMAND $ARGS;
    fi
  fi
fi