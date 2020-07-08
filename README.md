# mongo-configsrv

Mongo cluster config service. 

This is meant to be used along with [http://github.com/stutzlab/mongo-cluster-router](mongo-cluster-router) and [http://github.com/stutzlab/mongo-cluster-shard](mongo-cluster-shard).

**Check http://github.com/stutzlab/mongo-cluster-shard for more details and examples.**

## ENVs

* CONFIG_SERVER_NAME - name of the config server in cluster. defaults to 'configserver'
* CONFIG_SERVER_NODES - command separated list of config servers. defaults to configsrv1,configsrv2,configsrv3

