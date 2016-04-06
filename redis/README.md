Overview
--------

Redis Server container that is completely configurable via environment variables:

* **REDIS_BIND**: network interface to bind to (will expose a socket if set to localhost) 		- default: 127.0.0.1
* **REDIS_PORT**: network port to listen to - default: 6379
* **REDIS_DBCNT**: no. of databases available in server - default: 16
* **REDIS_DBFILE**: name of the database dump file - default: redis_01.rdb
* **REDIS_MASTER**: if set, this instance is a slave to this master (format: <ip:port>) - default: not set
* **REDIS_DBPWD**: if set, authentication with this password is required - default: not set
* **REDIS_LOGLVL**: log level of redis server (logs will be written to stdout & stderr) - default: notice

Standalone Server
----------------

To start a stand-alone instance just execute:

`docker run --name=redis01 -d appelgriebsch/redis`

This will start a local redis instance with the default configuration (see values above), that only allows connection via shared unix socket.To connect to this instance you have to use the unix socket provided via the volume like this:

`docker run --name=client01 --volumes-from=redis01 -i -t appelgriebsch/centos bash`

and in this container you can than execute:

`redis-cli -s /data/redis/<instance-hostname>/redis-<instance-hostname>.sock`

Master-Slave Replication
----------

To build a cluster of redis instances you have to open the connection to the public interface. Therefore start the first instance (the MASTER instance) like this:

`docker run --name=redis01 -e REDIS_BIND=0.0.0.0 -d appelgriebsch/redis`

Additional slave instances can be added like this:

`docker run --name=redis<xy> --link=redis01:redis01 --volumes-from=redis01 -e REDIS_BIND=0.0.0.0 -e REDIS_MASTER=redis01 -d appelgriebsch/redis`

Note: we are linking to the master (here: redis01) for easier IP address lookup within the slave container. Additionally we share the data volume from the master (here: redis01) into the slaves to have all data files on one mountable data directory, which allows easy backup later on.
