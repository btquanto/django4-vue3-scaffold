if [[ $APP == "app" ]]; then
  if [[ "serve migrate makemigrations start stop restart status" =~ "$COMMAND" ]]; then
    if [[ "start stop restart status" =~ "$COMMAND" ]]; then
      MODE="root";
      [ -z "${ARGS[*]}" || "${ARGS[*]}"] && ARGS=(all)
    fi
    dkrcmp exec --user $([[ "$MODE" == "root" ]] && echo 0 || id -u) app cmd $COMMAND "${ARGS[@]}";
  elif [[ "$COMMAND" == "install" ]]; then
    dkrcmp exec --user $(id -u) app bash /src/_development/pip-install.sh "${ARGS[@]}";
  else
    dkrcmp exec --user $([[ "$MODE" == "root" ]] && echo 0 || id -u) app $COMMAND "${ARGS[@]}";
  fi
fi