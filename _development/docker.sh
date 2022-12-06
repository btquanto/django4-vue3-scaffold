function dkrcmp() {
  echo "docker compose --env-file $ENV_DOCKER \\
                -p $PROJECT $@;";
  docker compose --env-file $ENV_DOCKER -p $PROJECT "$@";
}

if [[ $APP == "docker" ]]; then
  [[ "$COMMAND" == "up" && -z "${ARGS[*]}" ]] && ARGS=(-d);
  [[ "$COMMAND" == "up" && "${ARGS[*]}" == "--fg" ]] && ARGS=();
  [[ "$COMMAND" == "logs" && -z "${ARGS[*]}" ]] && ARGS=(-f app);
  if [[ "$COMMAND" == "build" ]]; then
      echo "USER_ID=${USER_ID:-$(id -u)} docker compose --env-file $ENV_DOCKER build;";
      USER_ID=${USER_ID:-$(id -u)} docker compose --env-file "$ENV_DOCKER" build;
  else
    dkrcmp $COMMAND "${ARGS[@]}";
  fi
fi