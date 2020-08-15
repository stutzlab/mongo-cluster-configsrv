#!/bin/sh

set -e

#check for replica set status
echo 'rs.status().ok' | mongo localhost:27017/test --quiet | grep 1 

#check that this node appears in nodes list
mongo --eval "db.isMaster()" | grep $CONFIG_REPLICA_SET