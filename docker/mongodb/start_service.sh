#!/bin/bash

if ! [ -z "$MONGO_DBDIR" ]; then
  if ! [ -d "$MONGO_DBDIR/$HOSTNAME" ]; then
     echo Creating database path $MONGO_DBDIR/$HOSTNAME.
     mkdir -p $MONGO_DBDIR/$HOSTNAME
  fi
  echo Setting database path to $MONGO_DBDIR.
  cp /etc/mongod.conf $MONGO_DBDIR/$HOSTNAME/mongod.conf && \
  chown -R mongod:mongod $MONGO_DBDIR && \
  chmod -R 755 $MONGO_DBDIR/$HOSTNAME
  dbpath=`echo $MONGO_DBDIR/$HOSTNAME | sed -e 's/\//\\\\\//g'`
  sed -i "s/^\(storage.dbPath.*\)$/storage.dbPath: $dbpath/" $MONGO_DBDIR/$HOSTNAME/mongod.conf
fi

echo Checking network binding... $MONGO_BIND
if [ "$MONGO_BIND" == "127.0.0.1" ]; then
  echo Disable public network binding, connection has to take place via unix socket...
  echo "net.unixDomainSocket.enabled: true" >> $MONGO_DBDIR/$HOSTNAME/mongod.conf
  echo "net.unixDomainSocket.pathPrefix: $MONGO_DBDIR/$HOSTNAME" >> $MONGO_DBDIR/$HOSTNAME/mongod.conf
else
  echo Enabling network binding on IP $MONGO_BIND.
  sed -i "s/^\(net.bindIp.*\)$/net.bindIp: $MONGO_BIND/" $MONGO_DBDIR/$HOSTNAME/mongod.conf
fi

echo Checking network port... $MONGO_PORT
if ! [ -z "$MONGO_PORT" ]; then
  echo Enabling network port $MONGO_PORT.
  sed -i "s/^\(net.port.*\)$/net.port: $MONGO_PORT/" $MONGO_DBDIR/$HOSTNAME/mongod.conf
fi

echo Checking verbose logging information... $MONGO_VERBOSE
if ! [ "$MONGO_VERBOSE" == "0" ]; then
  echo Enabling verbose log level... $MONGO_VERBOSE
  sed -i "s/^\(systemLog.verbosity.*\)$/systemLog.verbosity: $MONGO_VERBOSE/" $MONGO_DBDIR/$HOSTNAME/mongod.conf
fi

/usr/bin/mongod -f $MONGO_DBDIR/$HOSTNAME/mongod.conf
