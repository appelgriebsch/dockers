#!/bin/bash
export MONGO_DBDIR=/data/mongodb

function replaceInFile() {

  local file=$1
  local searchFor=$2
  local replaceWith=$3

  sed -i "s/$searchFor/$replaceWith/g" $file
}

function addToFile() {

  local file=$1
  local line=$2

  echo $2 >> $1
}

function replaceInString() {

  local origString=$1
  local searchFor=$2
  local replaceWith=$3

  echo $(echo $origString | sed -e "s/$searchFor/$replaceWith/g")
}

function maskPath() {

  local path=$1
  local pathDelimiter="\/"
  local replacementPattern="\\\\\/"

  echo $(replaceInString $path $pathDelimiter $replacementPattern)
}

function waitForConnection() {

  local host=$1
  local port=$2

  while ! echo exit | nc $host $port; do sleep 10; done
}

function resolveIPAddress() {

  local host=$1

  if [ $host == $HOSTNAME ]; then
    local myIP=$(ip a s|sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')
    echo $myIP
  else
    local remoteIP=$(ping -q -c 1 -t 1 $host | grep PING | sed -e "s/^[^(]*[(]//" | sed -e "s/[)].*$//")
    echo $remoteIP
  fi
}

function createInstanceDirectories() {

  if [ -n "$MONGO_DBDIR" ]; then

    if ! [ -d "$MONGO_DBDIR/$HOSTNAME" ]; then
       echo Creating database path $MONGO_DBDIR/$HOSTNAME.
       mkdir -p $MONGO_DBDIR/$HOSTNAME
    fi

    echo Setting database path to $MONGO_DBDIR.
    cp /etc/mongod.conf $MONGO_DBDIR/$HOSTNAME/mongod.conf && \
    chown -R mongod:mongod $MONGO_DBDIR && \
    chmod -R 755 $MONGO_DBDIR/$HOSTNAME
    dbpath=$(maskPath $MONGO_DBDIR/$HOSTNAME)
    replaceInFile $MONGO_DBDIR/$HOSTNAME/mongod.conf "^\(storage.dbPath.*\)$" "storage.dbPath: $dbpath"
  fi

  return 0
}

function setupInstanceNetworking() {

  echo Checking network binding... $MONGO_BIND
  if [ "$MONGO_BIND" == "127.0.0.1" ]; then
    echo Disable public network binding, connection has to take place via unix socket...
    addToFile $MONGO_DBDIR/$HOSTNAME/mongod.conf "net.unixDomainSocket.enabled: true"
    addToFile $MONGO_DBDIR/$HOSTNAME/mongod.conf "net.unixDomainSocket.pathPrefix: $MONGO_DBDIR/$HOSTNAME"
  else
    echo Enabling network binding on IP $MONGO_BIND.
    replaceInFile $MONGO_DBDIR/$HOSTNAME/mongod.conf "^\(net.bindIp.*\)$" "net.bindIp: $MONGO_BIND"
  fi

  echo Checking network port... $MONGO_PORT
  if [ -n "$MONGO_PORT" ]; then
    echo Enabling network port $MONGO_PORT.
    replaceInFile $MONGO_DBDIR/$HOSTNAME/mongod.conf "^\(net.port.*\)$" "net.port: $MONGO_PORT"
  fi

  return 0
}

function configureReplicaSet() {

  echo Joining ReplicaSet... $MONGO_REPLSET
  addToFile $MONGO_DBDIR/$HOSTNAME/mongod.conf "replication.replSetName: $MONGO_REPLSET"

  MONGO_MASTER_IP='127.0.0.1'
  MONGO_MASTER_PORT=$MONGO_PORT

  if [ -n "$MONGO_MASTER" ]; then
    MONGO_MASTER_IP=$(replaceInString $MONGO_MASTER "^\([0-9A-Za-z._\-]*\):\([0-9]*\)$" "\1")
    MONGO_MASTER_PORT=$(replaceInString $MONGO_MASTER "^\([0-9A-Za-z._\-]*\):\([0-9]*\)$" "\2")
  fi

  local myIP=$(resolveIPAddress $HOSTNAME)

  addToFile /tmp/initInstance.js "// initialize and configure replica sets"
  addToFile /tmp/initInstance.js "var replStatus = rs.status();"
  addToFile /tmp/initInstance.js "var result = {};"
  addToFile /tmp/initInstance.js "if (replStatus.ok == 0) { result = rs.initiate({ _id: '$MONGO_REPLSET', version: 1, members: [ { _id: 0, host: '$myIP:$MONGO_PORT' } ]}); }"

  if ! [ "$MONGO_MASTER_IP" == "127.0.0.1" ]; then
    if [ "$MONGO_TYPE" == "normal" ]; then
      addToFile /tmp/initInstance.js "result = rs.add('$myIP:$MONGO_PORT');"
    else
      addToFile /tmp/initInstance.js "result = rs.add('$myIP:$MONGO_PORT', { arbiterOnly: true });"
      replaceInFile $MONGO_DBDIR/$HOSTNAME/mongod.conf "^\(storage.journal.enabled.*\)$" "storage.journal.enabled: false"
    fi
  fi

  addToFile /tmp/initInstance.js "printjson(result);"

  return 0
}

function configureConfigSrv() {

  return 0
}

function configureShardSrv() {

  return 0
}

function configureInstance() {

  echo Checking verbose logging information... $MONGO_LOGLVL
  if [ -n "$MONGO_LOGLVL" ]; then
    echo Enabling verbose log level... $MONGO_LOGLVL
    sed -i "s/^\(systemLog.verbosity.*\)$/systemLog.verbosity: $MONGO_LOGLVL/" $MONGO_DBDIR/$HOSTNAME/mongod.conf
  fi

  echo Checking instance type... $MONGO_TYPE
  case $MONGO_TYPE in
    normal)
      if [ -n "$MONGO_REPLSET" ]; then
        configureReplicaSet
      fi
      ;;
    arbiter)
      configureReplicaSet
      ;;
    config)
      configureConfigSrv
      ;;
    shard)
      configureShardSrv
      ;;
    *)
      echo Unknown instance type: $MONGO_TYPE
      exit 1
  esac

  return 0
}

function startInstance() {

  INSTANCE_CMD="/usr/bin/mongod -f $MONGO_DBDIR/$HOSTNAME/mongod.conf"

  if [ -f /tmp/initInstance.js ]; then
    echo Local configuration script found. Starting instance in background...
    # Turn on monitor mode to allow switching between background and foreground processes
    set -m
    $INSTANCE_CMD &
    # wait for connection to MASTER server and LOCALHOST
    waitForConnection $MONGO_MASTER_IP $MONGO_MASTER_PORT && waitForConnection 127.0.0.1 $MONGO_PORT
    echo Executing local configuration script on server $MONGO_MASTER_IP:$MONGO_MASTER_PORT
    initStatus=$(mongo --host $MONGO_MASTER_IP --port $MONGO_MASTER_PORT --quiet < /tmp/initInstance.js)
    echo Initialize status: $initStatus
    fg %1
  else
    $INSTANCE_CMD
  fi

  return 0
}

createInstanceDirectories && setupInstanceNetworking && \
 configureInstance && startInstance
