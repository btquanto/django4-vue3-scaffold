function dkrcmp() {
  if [ -z $U_ID ]; then U_ID="$(id -u)"; fi;
  if [ -z $G_ID ]; then G_ID="$(id -g)"; fi;

  DOCKER_USER="$U_ID:$G_ID";
  echo "U_ID=$U_ID G_ID=$G_ID DOCKER_USER=$DOCKER_USER \\
docker compose --env-file $ENV_DOCKER \\
                -f docker-services.yml -f docker-app.yml \\
                -p $PROJECT $@;";
  U_ID=$U_ID G_ID=$G_ID DOCKER_USER=$DOCKER_USER \
  docker compose --env-file $ENV_DOCKER \
                  -f docker-services.yml -f docker-app.yml  \
                  -p $PROJECT "$@";
}


if [[ $APP == "docker" ]]; then
  if [[ $COMMAND == "up" && -z "$ARGS" ]]; then
    ARGS="-d";
  fi
  if [[ $COMMAND == "logs" && -z "$ARGS" ]]; then
    ARGS="-f app";
  fi
  dkrcmp $COMMAND $ARGS;
fi