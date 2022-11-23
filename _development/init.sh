function init() {

  if [ -f "config/.docker" ]; then
      source "config/.docker";
  else
      printf "Docker environment file (config/.docker) not found. Generating...\n";
      cp config/_docker config/.docker;
      printf "'config/.docker' is added to your project. You may want to update this file manually.\n\n"
  fi

  if [ ! -z "$DJANGO_CONFIG_MODULE" ]; then
      CONFIG_FILE="backend/${DJANGO_CONFIG_MODULE//\.//}.py";
  else
      CONFIG_FILE="backend/config/local.py"
  fi

  if [ ! -f "config/.django" ]; then
      printf "Django environment file (config/.django) not found. Generating...\n";
      cp config/_django config/.django;
      printf "'config/.django' is added to your project. You may want to update this file manually.\n\n"
  fi

  if [ ! -f $CONFIG_FILE ]; then
      printf "Django local configuration file ('$CONFIG_FILE') not found. Generating...\n"
      cp backend/config/config.py.template $CONFIG_FILE;
      printf "'$CONFIG_FILE' is added to your project. You may want to update this file manually.\n\n"
  fi
}

if [[ $APP == "init" ]]; then init; fi