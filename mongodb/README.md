 Overview
----------

MongoDB container that is completely configurable via environment variables:

* **MONGO_BIND**: network interface to bind to (will expose a socket if set to localhost) - default: 127.0.0.1
* **MONGO_PORT**: network port to listen to - default: 27017 (mongod service)
* **MONGO_DBDIR**: path to the database files (should be a mountable volume) - default: /data/mongodb
* **MONGO_LOGLVL**: verbosity (log) level of mongodb server (logs will be written to stdout & stderr) - default: 0
* **MONGO_TYPE**: mongodb type for this instance (normal, arbiter, config-server, shard-server) - default: normal
* **MONGO_REPLSET**: name of replica set (if available) - default: not set
* **MONGO_MASTER**: address of master (PRIMARY) server (ip:port) - default: not set
* **MONGO_CONFIG**: address of config server (ip:port) - default: not set

Standalone
----------

To start a stand-alone instance just execute:

`docker run --name=mongodb01 -d appelgriebsch/mongodb`

This will start a local mongodb instance with the default configuration (see values above), that only allows connection via shared unix socket.To connect to this instance you have to use the unix socket provided via the volume like this:

`docker run --name=client01 --volumes-from=mongodb01 -i -t appelgriebsch/centos bash`

and in this container you can than execute:

`mongo --host /data/mongodb/<instance-hostname>/mongodb-<instance-port>.sock`

ReplicaSets
----------

To build a cluster of mongodb instances you have to open the connection to the public interface. Therefore start the first instance (the MASTER or PRIMARY instance) like this:

`docker run --name=mongodb01 -e MONGO_BIND=0.0.0.0 -e MONGO_REPLSET=replica01 -d appelgriebsch/mongodb`

Additional replicaset instances can be added like this:

`docker run --name=mongodb<xy> --link=mongodb01:mongodb01 --volumes-from=mongodb01 -e MONGO_BIND=0.0.0.0 -e MONGO_REPLSET=replica01 -e MONGO_MASTER=mongodb01:27017 -d appelgriebsch/mongodb`

Note: we are linking to the master (here: mongodb01) for easier IP address lookup within the secondary container. Additionally we share the data volume from the master (here: mongodb01) into the secondary container to have all data files on one mountable data directory, which allows easy backup later on. 

If you want to add an arbiter to the replicaset you have to set the environment variable for the MONGO_TYPE from `normal` to `arbiter` accordingly.

Shards
----------

Any MONGO_TYPE other than `normal` and `arbiter` are not supported by the start_instance script. I'm working on those. Please stay tuned! 

**tbd**
