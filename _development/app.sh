if [[ $APP == "app" ]]; then
  if [[ "serve migrate makemigrations start stop restart status" =~ "$COMMAND" ]]; then
    if [[ "start stop restart status" =~ "$COMMAND"  && -z "$ARGS" ]]; then
      ARGS="all";
    fi
    dkrcmp exec --user $(id -u) app cmd "$COMMAND" "$ARGS";
  elif [[ "$COMMAND" == "pip-install" ]]; then
    if [[ ! -z "$ARGS" ]]; then
      dkrcmp exec --user $(id -u) app bash /src/_development/pip-install.sh "$ARGS";
    else  
      dkrcmp exec --user $(id -u) app bash /src/_development/pip-install.sh;
    fi
  else
    if [[ "$MODE" == "root" ]]; then
      dkrcmp exec app "$COMMAND" "$ARGS";
    else
      dkrcmp exec --user $(id -u) app "$COMMAND" "$ARGS";
    fi
  fi
fi