function dkrcmp() {
  echo "docker compose --env-file $ENV_DOCKER \\
                -p $PROJECT $@;";
  docker compose --env-file $ENV_DOCKER -p $PROJECT "$@";
}

if [ $APP = "docker" ]; then
  if [ "$COMMAND" = "up" ]; then
    [ -z "${ARGS[@]}" ] && ARGS=(-d);
    [ "${ARGS[@]}" = "--fg" ] && ARGS=();
  fi
  if [ "$COMMAND" = "logs" ]; then
    [ -z "${ARGS[@]}" ] && ARGS=(app);
    [ ${#ARGS[@]} -eq 1 ] && ARGS=("-f" "${ARGS[@]}");
  fi
  if [ "$COMMAND" = "build" ]; then
      echo "USER_ID=${USER_ID:-$(id -u)} docker compose --env-file $ENV_DOCKER build;";
      USER_ID=${USER_ID:-$(id -u)} docker compose --env-file "$ENV_DOCKER" build;
  else
    dkrcmp $COMMAND "${ARGS[@]}";
  fi
fi