#!/bin/bash

if ! [ -z "$MONGO_DBDIR" ]; then
  if ! [ -d "$MONGO_DBDIR/$HOSTNAME" ]; then
     echo Creating database path $MONGO_DBDIR/$HOSTNAME.
     mkdir -p $MONGO_DBDIR/$HOSTNAME && \
     chown -R mongod:mongod $MONGO_DBDIR && \
     chmod -R 750 $MONGO_DBDIR
  fi
  echo Setting database path to $MONGO_DBDIR.
  cp /etc/mongod.conf $MONGO_DBDIR/$HOSTNAME/mongod.conf && \
  dbpath=`echo $MONGO_DBDIR/$HOSTNAME | sed -e 's/\//\\\\\//g'`
  sed -i "s/^\(dbpath.*\)$/# \1\ndbpath = $dbpath/" $MONGO_DBDIR/$HOSTNAME/mongod.conf
fi

echo Checking network binding... $MONGO_BIND
if [ "$MONGO_BIND" == "127.0.0.1" ]; then
  echo Disable public network binding, connection has to take place via unix socket...
  echo "unixSocketPrefix = $MONGO_DBDIR/$HOSTNAME" >> $MONGO_DBDIR/$HOSTNAME/mongod.conf
else
  echo Enabling network binding on IP $MONGO_BIND.
  sed -i "s/^\(bind_ip.*\)$/# \1\nbind_ip = $MONGO_BIND/" $MONGO_DBDIR/$HOSTNAME/mongod.conf
fi

echo Checking network port... $MONGO_PORT
if ! [ -z "$MONGO_PORT" ]; then
  echo Enabling network port $MONGO_PORT.
  sed -i "s/^\(#port.*\)$/\1\nport = $MONGO_PORT/" $MONGO_DBDIR/$HOSTNAME/mongod.conf
fi

echo Checking verbose logging information... $MONGO_VERBOSE
if [ "$MONGO_VERBOSE" == "1" ]; then
  echo Enabling verbose log level...
  sed -i "s/^\(#verbose.*\)$/\1\nverbose = true/" $MONGO_DBDIR/$HOSTNAME/mongod.conf
fi

/usr/bin/mongod -f $MONGO_DBDIR/$HOSTNAME/mongod.conf
