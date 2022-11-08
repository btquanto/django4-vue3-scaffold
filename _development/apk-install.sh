check_package_installed() {
  installed=`apk info | grep $1`;
  if [[ -z "$installed" ]]; then
    echo "Package {$1} is not installed";
    return 1;
  fi
  return 0;
}

if [ $# -eq 0 ]
then
  echo "Error: Empty package name list";
  exit 0;
fi

deps=""

for package in $@; do
  check_package_installed $package;
  if [ $? -eq 1 ]
  then
    if [ -z "$deps" ]
    then
      deps="$package";
    else
      deps="$deps $package";
    fi
  fi
done;

if [ ! -z "$deps" ]
then
  apk update;
fi

if [ ! -z "$deps" ]
then
  echo "Installing packages: '$deps'";
  apk add --update $deps;
fi
