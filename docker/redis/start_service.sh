#!/bin/bash

echo Checking network binding... $REDIS_BIND
if [ "$REDIS_BIND" == "127.0.0.1" ]; then
  echo Disable public network binding, connection has to take place via unix socket...
  sed -i "s/^\(# unixsocket .*\)$/\1\nunixsocket \/data\/redis\/redis-$REDIS_PORT.sock/" /etc/redis.conf
  sed -i "s/^\(# unixsocketperm .*\)$/\1\nunixsocketperm 755/" /etc/redis.conf
else
  echo Enabling network binding on IP $REDIS_BIND.
  sed -i "s/^\(bind .*\)$/# \1\nbind $REDIS_BIND/" /etc/redis.conf
fi

echo Checking network port... $REDIS_PORT
if ! [ -z "$REDIS_PORT" ]; then
  echo Enabling network port $REDIS_PORT.
  sed -i "s/^\(port .*\)$/# \1\nport $REDIS_PORT/" /etc/redis.conf
fi

echo Checking no. of databases... $REDIS_DBCNT
if ! [ -z "$REDIS_DBCNT" ]; then
  echo Setting up for $REDIS_DBCNT databases.
  sed -i "s/^\(databases .*\)$/# \1\ndatabases $REDIS_DBCNT/" /etc/redis.conf
fi

echo Checking database path... $REDIS_DBFILE
if ! [ -z "$REDIS_DBFILE" ]; then
  echo Setting db filename to $REDIS_DBFILE.
  sed -i "s/^\(dbfilename .*\)$/# \1\ndbfilename $REDIS_DBFILE/" /etc/redis.conf
fi

if ! [ -z "$REDIS_DBDIR" ]; then
  if ! [ -d "$REDIS_DBDIR" ]; then
     echo Creating database path $REDIS_DBDIR.
     mkdir -p $REDIS_DBDIR && \
     chown -R redis:redis $REDIS_DBDIR && \
     chmod -R 750 $REDIS_DBDIR
  fi
  echo Setting database path to $REDIS_DBDIR.
  dbpath=`echo $REDIS_DBDIR | sed -e 's/\//\\\\\//g'`
  sed -i "s/^\(dir .*\)$/# \1\ndir $dbpath/" /etc/redis.conf 
fi

echo Checking security settings for database server...
if ! [ "$REDIS_DBPWD" == "''" ]; then
  echo Securing database server with password.
  sed -i "s/^\(# requirepass .*\)$/\1\nrequirepass $REDIS_DBPWD/" /etc/redis.conf 
  sed -i "s/^\(# masterauth .*\)$/\1\nmasterauth $REDIS_DBPWD/" /etc/redis.conf 
fi

echo Checking database node type...$REDIS_MASTER
if ! [ "$REDIS_MASTER" == "''" ]; then
  # extract ip and port from env variable
  REDIS_MASTER_IP=1
  REDIS_MASTER_PORT=2
  echo Setting up slave node to $REDIS_MASTER_IP $REDIS_MASTER_PORT
  sed -i "s/^\(# slaveof .*\)$/\1\nslaveof $REDIS_MASTER_IP $REDIS_MASTER_PORT/" /etc/redis.conf 
fi

sudo -u redis /usr/bin/redis-server /etc/redis.conf

# if ! [ -z "$REDIS" ]; then echo hello; fi
#  sed -i "s/^\(dir .*\)$/# \1\ndir \/data\/redis\/db/" /etc/redis.conf && \
