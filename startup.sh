#!/bin/bash

set -e
# set -x

if [ "$CONFIG_SERVER_NODES" == "" ]; then
    echo "CONFIG_SERVER_NODES is required"
    exit 1
fi

/config.sh &

echo "Starting Mongo configsrv..."
mongod --port 27017 --configsvr --replSet $CONFIG_REPLICA_SET --bind_ip_all
