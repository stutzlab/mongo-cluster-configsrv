#!/bin/bash

echo "Waiting for mongo server to be available at 27017..."
while ! nc -z 127.0.0.1 27017; do sleep 0.5; done
sleep 1

MAX_RETRIES=9999
if [ "$INIT_CONFIG_NODES" != "" ]; then
   MAX_RETRIES=5
fi

echo "Verifying if this config node is already part of a config replicaset..."
C=0
while [ (( "$C" < "$MAX_RETRIES" )); do
   mongo --eval "db.isMaster()" | grep $CONFIG_REPLICA_SET
   if [ "$?" == "0" ]; then
      mongo --eval "db.isMaster()"
      echo ">>> THIS NODE IS PART OF A CONFIG REPLICASET"
      exit 0
   fi
   C=($C+1)
   echo "."
   if [ "$MAX_RETRIES" == "9999" ]; then
      break
   fi
   sleep 1
done

if [ "$INIT_CONFIG_NODES" == "" ]; then
  echo ">>> THIS NODE IS NOT PART OF A CONFIG. ADD IT IN ORDER TO BE ACTIVE"
  echo "Tip: On master node, execute rs.add( { host: \"[host]\", priority: 0, votes: 0 } )"
  exit 0
fi

echo "Generating configsrv config"
echo ""

rm /init-configserver.js
cat <<EOT >> /init-configserver.js
rs.initiate(
   {
EOT

echo "_id: \"$CONFIG_REPLICA_SET\"," >> /init-configserver.js

cat <<EOT >> /init-configserver.js
      configsvr: true,
      version: 1,
      members: [
EOT

IFS=',' read -r -a NODES <<< "$INIT_CONFIG_NODES"
S=""
c=0
for N in "${NODES[@]}"; do
    echo "${S}{ _id: $c, host : \"$N:27017\" }" >> /init-configserver.js
    S=","
    c=$((c+1))
done

cat <<EOT >> /init-configserver.js
      ]
   }
)
EOT

echo "/init-configserver.js"
cat /init-configserver.js

echo "CONFIGURING CLUSTER CONFIG SERVER..."
mongo < /init-configserver.js
echo ">>> CONFIG SERVER INITIALIZED SUCCESSFULLY"

