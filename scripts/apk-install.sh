check_package_installed() {
  installed=`apk info -vv | grep -o $package`;
  return $?;
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
    echo "Package '$package' has not been installed";
    if [ -z "$deps" ]
    then
      deps="$package";
    else
      deps="$deps $package";
    fi
  fi
done;

apk update;

if [ ! -z "$deps" ]
then
  echo "Installing packages: '$deps'";
  apk --update add $deps;
fi
