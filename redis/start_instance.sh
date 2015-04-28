#!/bin/bash

function replaceInFile() {

  local file=$1
  local searchFor=$2
  local replaceWith=$3

  sed -i "s/$searchFor/$replaceWith/g" $file
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

function createInstanceDirectories() {

  if [ -n "$REDIS_DBDIR" ]; then

    if ! [ -d "$REDIS_DBDIR/$HOSTNAME" ]; then
       echo Creating database path $REDIS_DBDIR/$HOSTNAME.
       mkdir -p $REDIS_DBDIR/$HOSTNAME
    fi

    echo Setting database path to $REDIS_DBDIR.
    cp /etc/redis.conf $REDIS_DBDIR/$HOSTNAME/redis-server.conf && \
    chown -R redis:redis $REDIS_DBDIR && \
    chmod -R 755 $REDIS_DBDIR/$HOSTNAME
    dbpath=$(maskPath $REDIS_DBDIR/$HOSTNAME)
    replaceInFile $REDIS_DBDIR/$HOSTNAME/redis-server.conf "^\(dir .*\)$" "# \1\ndir $dbpath"
  fi

  return 0
}

function setupInstanceNetworking() {

  echo Checking network binding... $REDIS_BIND

  if [ "$REDIS_BIND" == "127.0.0.1" ]; then
    echo Disable public network binding, connection has to take place via unix socket...
    socketpath=$(maskPath $REDIS_DBDIR/$HOSTNAME)
    replaceInFile $REDIS_DBDIR/$HOSTNAME/redis-server.conf "^\(# unixsocket .*\)$" "\1\nunixsocket $socketpath\/redis-$HOSTNAME.sock"
    replaceInFile $REDIS_DBDIR/$HOSTNAME/redis-server.conf "^\(# unixsocketperm .*\)$" "\1\nunixsocketperm 755"
  else
    echo Enabling network binding on IP $REDIS_BIND.
    replaceInFile $REDIS_DBDIR/$HOSTNAME/redis-server.conf "^\(bind .*\)$" "# \1\nbind $REDIS_BIND"
  fi

  echo Checking network port... $REDIS_PORT
  if [ -n "$REDIS_PORT" ]; then
    echo Enabling network port $REDIS_PORT.
    replaceInFile $REDIS_DBDIR/$HOSTNAME/redis-server.conf "^\(port .*\)$" "# \1\nport $REDIS_PORT"
  fi

  return 0
}

function configureInstance() {

  echo Checking no. of databases... $REDIS_DBCNT
  if [ -n "$REDIS_DBCNT" ]; then
    echo Setting up for $REDIS_DBCNT databases.
    replaceInFile $REDIS_DBDIR/$HOSTNAME/redis-server.conf "^\(databases .*\)$" "# \1\ndatabases $REDIS_DBCNT"
  fi

  echo Checking database path... $REDIS_DBFILE
  if [ -n "$REDIS_DBFILE" ]; then
    echo Setting db filename to $REDIS_DBFILE.
    replaceInFile $REDIS_DBDIR/$HOSTNAME/redis-server.conf "^\(dbfilename .*\)$" "# \1\ndbfilename $REDIS_DBFILE"
  fi

  echo Checking security settings for database server...
  if [ -n "$REDIS_DBPWD" ]; then
    echo Securing database server with password.
    replaceInFile $REDIS_DBDIR/$HOSTNAME/redis-server.conf "^\(# requirepass .*\)$" "\1\nrequirepass $REDIS_DBPWD"
    replaceInFile $REDIS_DBDIR/$HOSTNAME/redis-server.conf "^\(# masterauth .*\)$" "\1\nmasterauth $REDIS_DBPWD"
  fi

  echo Checking database node type...$REDIS_MASTER
  if [ -n "$REDIS_MASTER" ]; then
    # extract ip and port from env variable
    REDIS_MASTER_IP=$(replaceInString $REDIS_MASTER "^\([0-9A-Za-z._\-]*\):\([0-9]*\)$" "\1")
    REDIS_MASTER_PORT=$(replaceInString $REDIS_MASTER "^\([0-9A-Za-z._\-]*\):\([0-9]*\)$" "\2")

    # cross-check for linked services (REDIS_MASTER_IP contains name of linked container)
    # build name of environment variable containing linked service ip_address
    ENV_LINKED_REDIS_IP=${REDIS_MASTER_IP^^}_PORT_${REDIS_MASTER_PORT}_TCP_ADDR
    ENV_LINKED_REDIS_PORT=${REDIS_MASTER_IP^^}_PORT_${REDIS_MASTER_PORT}_TCP_PORT

    # try to figure out linked service IP & port
    if [ -n "${!ENV_LINKED_REDIS_IP}" ]; then
      # replace IP & port of redis master with linked container settings
      REDIS_MASTER_IP=${!ENV_LINKED_REDIS_IP}
      REDIS_MASTER_PORT=${!ENV_LINKED_REDIS_PORT}
    fi

    echo Setting up slave node to $REDIS_MASTER_IP $REDIS_MASTER_PORT
    replaceInFile $REDIS_DBDIR/$HOSTNAME/redis-server.conf "^\(# slaveof .*\)$" "\1\nslaveof $REDIS_MASTER_IP $REDIS_MASTER_PORT"
  fi

  echo Checking database log level...$REDIS_LOGLVL
  if [ -n "$REDIS_LOGLVL" ]; then
    echo Setting up log level $REDIS_LOGLVL.
    replaceInFile $REDIS_DBDIR/$HOSTNAME/redis-server.conf "^\(loglevel .*\)$" "# \1\nloglevel $REDIS_LOGLVL"
  fi
}

function startInstance() {

  /usr/bin/redis-server $REDIS_DBDIR/$HOSTNAME/redis-server.conf
}

createInstanceDirectories && setupInstanceNetworking && \
 configureInstance && startInstance
