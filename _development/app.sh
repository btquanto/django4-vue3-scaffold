if [[ $APP == "app" ]]; then
  if [[ "serve migrate makemigrations start stop restart status" =~ "$COMMAND" ]]; then
    if [[ "start stop restart status" =~ "$COMMAND"  && -z "$ARGS" ]]; then
      ARGS="all";
    fi
    if [ -z "$ARGS" ]; then
      dkrcmp exec --user $(id -u) app cmd "$COMMAND";
    else
      dkrcmp exec --user $(id -u) app cmd "$COMMAND" "$ARGS";
    fi
  elif [[ "$COMMAND" == "pip-install" ]]; then
    if [[ ! -z "$ARGS" ]]; then
      dkrcmp exec --user $(id -u) app bash /src/_development/pip-install.sh "$ARGS";
    else  
      dkrcmp exec --user $(id -u) app bash /src/_development/pip-install.sh;
    fi
  else
    if [[ "$MODE" == "root" ]]; then
      if [ -z "$ARGS" ]; then
        dkrcmp exec app "$COMMAND";
      else
        dkrcmp exec app "$COMMAND" "$ARGS";
      fi
    else
      if [ -z "$ARGS" ]; then
        dkrcmp exec --user $(id -u) app "$COMMAND";
      else
        dkrcmp exec --user $(id -u) app "$COMMAND" "$ARGS";
      fi
    fi
  fi
fi