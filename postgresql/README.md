 Overview
----------

PostgreSQL container that is completely configurable via environment variables:

* **PGSQL_BIND**: network interface to bind to (will expose a socket if set to localhost) - default: 127.0.0.1
* **PGSQL_NETMASK**: netmask of the network segment the server listen to - default: for localhost only binding
* **PGSQL_PORT**: network port to listen to - default: 5432 (pgsql service)
* **PGSQL_LOGLVL**: verbosity (log) level of pgsql server (logs will be written to stdout & stderr) - default: 0
* **PGSQL_DBADMIN**: default database user credentials <name:pwd> (name is lowercase)
* **PGSQL_DBNAME**: default database for user (dbname is lowercase)

Standalone
----------

To start a stand-alone instance just execute:

`docker run --name=pgsql01 -d appelgriebsch/postgresql`

**tbd**
