check_package_installed() {
  result=`dpkg-query -W -f '${Status}\n' $@ 2>&1 | grep 'install ok installed'`;
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
    fi;
  fi;
done;

if [ ! -z "$deps" ]
then
  echo "Installing packages: '$deps'";
  apt update;
  apt install -y $deps;
fi;
