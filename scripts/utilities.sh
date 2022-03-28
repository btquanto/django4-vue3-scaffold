
function dkrcmp() {
  echo "docker-compose --env-file $env_docker -p $project $@";
  docker-compose --env-file $env_docker -p $project $@;
}

function build() {
  if [[ "$1" == 'dev' ]]; then
    dkrcmp exec node yarn $@;
  elif [[ "$1" == 'watch' ]]; then
    dkrcmp exec node yarn dev --watch;
  else
    dkrcmp exec node yarn build;
  fi
}

function init() {

  if [ -f "config/.env_docker" ]; then
      source "config/.env_docker";
  else
      echo "Docker environment file (config/.env_docker) not found.";
      echo "Please create a 'config/.env_docker' from the template 'config/_env_docker'.";
      echo "Quick command: cp config/_env_docker config/.env_docker";
      exit 1;
  fi

  if [ ! -z "$DJANGO_CONFIG_MODULE" ]; then
      CONFIG_FILE="backend/${DJANGO_CONFIG_MODULE//\.//}.py";
  else
      CONFIG_FILE="backend/config/local.py"
  fi

  if [ ! -f "config/.env" ]; then
      echo "'config/.env' not found. Generating...";
      cp config/_env config/.env;
      echo "'config/.env' is added to your project. You may want to update this file manually."
  fi

  if [ ! -f $CONFIG_FILE ]; then
      echo "'$CONFIG_FILE' not found. Generating..."
      cp backend/config/config.py.template $CONFIG_FILE;
      echo "'$CONFIG_FILE' is added to your project. You may want to update this file manually."
  fi
  dkrcmp exec node apk --no-cache add git ssh;
  dkrcmp exec node yarn install;
}

function help() {
  echo  << EOF
Multiple lines
Multiple lines
Multiple lines
EOF
}