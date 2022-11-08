function init() {

  if [ -f "config/.docker" ]; then
      source "config/.docker";
  else
      echo "Docker environment file (config/.docker) not found.";
      echo "Please create a 'config/.docker' from the template 'config/_docker'.";
      echo "Quick command: cp config/_docker config/.docker";
      exit 1;
  fi

  echo "Creating 'dist' folder...";
  echo "mkdir -p dist;";
  mkdir -p dist;

  if [ ! -z "$DJANGO_CONFIG_MODULE" ]; then
      CONFIG_FILE="backend/${DJANGO_CONFIG_MODULE//\.//}.py";
  else
      CONFIG_FILE="backend/config/local.py"
  fi

  if [ ! -f "config/.django" ]; then
      echo "'config/.django' not found. Generating...";
      cp config/_django config/.django;
      echo "'config/.django' is added to your project. You may want to update this file manually."
  fi

  if [ ! -f $CONFIG_FILE ]; then
      echo "'$CONFIG_FILE' not found. Generating..."
      cp backend/config/config.py.template $CONFIG_FILE;
      echo "'$CONFIG_FILE' is added to your project. You may want to update this file manually."
  fi
}

if [[ $APP == "init" ]]; then init; fi