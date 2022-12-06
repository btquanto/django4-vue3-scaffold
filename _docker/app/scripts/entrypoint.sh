#!/bin/bash

# Startup script
su $APP_USER -c /startup.sh;

# Supervisord
supervisord -c /etc/supervisor/supervisord.conf;

# Run nginx unit
# docker-entrypoint unitd --no-daemon --control unix:/var/run/control.unit.sock;

sleep infinity;