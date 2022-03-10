#!/bin/bash
set -u;

# Checking apps dependencies
echo "Server starting..."

REQUIREMENTS="requirements.txt";

read -r -d '' CODE << EOM
import pkg_resources

with open('requirements.txt', 'r') as fp:
    dependencies = fp.readlines()
try:
    pkg_resources.require(dependencies)
    exit(0)
except Exception as ex:
    import traceback
    print(ex)
    exit(1)
EOM

python3 -c "$CODE"

if [ $? -eq 0 ]; then
    echo "All dependencies from 'requirements.txt' are met";
else
    if [ -f $REQUIREMENTS ]; then
        echo "Installing missing dependencies";
        # Upgrade pip
        pip3 install --no-index --find-links=/wheeldir -U pip;
        # Build wheel
        pip3 wheel --find-links=/wheeldir -w /wheeldir -r $REQUIREMENTS;
        # Install from wheel
        pip3 install --no-index --find-links=/wheeldir -r $REQUIREMENTS;
        
        echo "All dependencies are installed";
    fi;
fi

if [ ! -f /etc/nginx/ssl/server.crt ]; then
    # SSL Certificates
    cmd renew-ssl
fi

# Services
supervisord

echo "Server started..."
sleep infinity;