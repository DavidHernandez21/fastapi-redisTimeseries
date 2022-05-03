#!/bin/bash

set -eu

HOST=${HOST:-0.0.0.0}
PORT=${PORT:-3000}
LOG_LEVEL=${LOG_LEVEL:-info}
APP_MODULE=${APP_MODULE:-app.main:app}


# If there's a prestart.sh script in the /app directory, run it before starting
PRE_START_PATH=/app/prestart.sh

echo "Checking for script in $PRE_START_PATH"
if [ -f $PRE_START_PATH ] ; then
    echo "Running script $PRE_START_PATH"
    # shellcheck source=/dev/null
    . "$PRE_START_PATH"
else 
    echo "There is no script $PRE_START_PATH"
fi

# Start Uvicorn with live reload
exec uvicorn --reload --host "$HOST" --port "$PORT" --log-level "$LOG_LEVEL" "$APP_MODULE"