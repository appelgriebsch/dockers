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

echo Checking verbose logging information... $MONGO_LOGLVL
if ! [ -z "$MONGO_LOGLVL" ]; then
  echo Enabling verbose log level... $MONGO_LOGLVL
  sed -i "s/^\(systemLog.verbosity.*\)$/systemLog.verbosity: $MONGO_LOGLVL/" $MONGO_DBDIR/$HOSTNAME/mongod.conf
fi

echo Checking ReplicaSet information... $MONGO_REPSET
if ! [ "$MONGO_REPSET" == "''" ]; then
  echo Joining ReplicaSet... $MONGO_REPSET
  echo "replication.replSetName: $MONGO_REPSET" >> $MONGO_DBDIR/$HOSTNAME/mongod.conf

  MONGO_MASTER_IP = '127.0.0.1'
  MONGO_MASTER_PORT = $MONGO_PORT
   
  if ! [ "$MONGO_HOST" == "''" ]; then
    MONGO_MASTER_IP=`echo $MONGO_MASTER | sed -e 's/^\([0-9A-Za-z._\-]*\):\([0-9]*\)$/\1/'`
    MONGO_MASTER_PORT=`echo $MONGO_MASTER | sed -e 's/^\([0-9A-Za-z._\-]*\):\([0-9]*\)$/\2/'`
  else
    echo Starting temporary background instance to configure cluster...
    /usr/bin/mongod -f $MONGO_DBDIR/$HOSTNAME/mongod.conf --fork --syslog --pidfile /tmp/mongod.pid
  fi

  echo "Checking ReplicaSet status on $MONGO_MASTER_IP:$MONGO_MASTER_PORT"
  replSetStatus=`mongo --host $MONGO_MASTER_IP --port $MONGO_MASTER_PORT --eval "rs.status().ok" --quiet`
  echo ReplicaSet status... $replSetStatus
  replConfigStatus = 0

  if [ "$replSetStatus" == "0" ]; then
    replConfigStatus=`mongo --host $MONGO_MASTER_IP --port $MONGO_MASTER_PORT --eval "rs.initialize()" --quiet`
  else
    replConfigStatus=`mongo --host $MONGO_MASTER_IP --port $MONGO_MASTER_PORT --eval "rs.add($HOSTNAME)" --quiet`
  fi
  echo ReplicaSet initialization status... $replConfigStatus
  
  if [ -f /tmp/mongod.pid ]; then
    echo Stopping temporary background instance...
    dbStatus=`mongo --host $MONGO_MASTER_IP --port $MONGO_MASTER_PORT --eval "db.shutdownServer()" --quiet`
    echo $dbStatus
  fi
fi

/usr/bin/mongod -f $MONGO_DBDIR/$HOSTNAME/mongod.conf
