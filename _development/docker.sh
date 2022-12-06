function dkrcmp() {
  echo "docker compose --env-file $ENV_DOCKER \\
                -p $PROJECT $@;";
  docker compose --env-file $ENV_DOCKER -p $PROJECT "$@";
}

if [[ $APP == "docker" ]]; then
  if [[ "$COMMAND" == "up" && -z "$ARGS" ]]; then
    ARGS="-d";
  fi
  if [[ "$COMMAND" == "up" && "$ARGS" == "--no-daemon" ]]; then
    ARGS="";
  fi
  if [[ "$COMMAND" == "logs" && -z "$ARGS" ]]; then
    ARGS="-f app";
  fi
  if [[ "$COMMAND" == "build" ]]; then
      USER_ID=${USER_ID:-$(id -u)};
      echo "USER_ID=$USER_ID docker compose --env-file $ENV_DOCKER build;";
      USER_ID=$USER_ID docker compose --env-file "$ENV_DOCKER" build;
  else
    if [ -z "$ARGS" ]; then
      dkrcmp "$COMMAND";
    else
      dkrcmp "$COMMAND" "$ARGS";
    fi
  fi
fi