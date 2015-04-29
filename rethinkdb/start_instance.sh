#!/bin/bash

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

  if [ -n "$RTDB_DBDIR" ]; then

    if ! [ -d "$RTDB_DBDIR/$HOSTNAME" ]; then
       echo Creating database path $RTDB_DBDIR/$HOSTNAME.
       mkdir -p $RTDB_DBDIR/$HOSTNAME
    fi

    echo Setting database path to $RTDB_DBDIR.
    cp /etc/rethinkdb/default.conf.sample $RTDB_DBDIR/$HOSTNAME/rethinkdb.conf && \
    chown -R rethinkdb:rethinkdb $RTDB_DBDIR && \
    chmod -R 755 $RTDB_DBDIR/$HOSTNAME
    dbpath=$(maskPath $RTDB_DBDIR/$HOSTNAME)
    replaceInFile $RTDB_DBDIR/$HOSTNAME/rethinkdb.conf "^\(directory.*\)$" "directory=$dbpath"
  fi

  return 0
}

function setupInstanceNetworking() {

  echo Checking network binding... $RTDB_BIND

  if [ "$RTDB_BIND" == "127.0.0.1" ]; then
    echo Disable public network binding, connection has to take place via unix socket...
    socketpath=$(maskPath $RTDB_DBDIR/$HOSTNAME)
  else
    echo Enabling network binding on IP $RTDB_BIND.
    replaceInFile $RTDB_DBDIR/$HOSTNAME/rethinkdb.conf "^\(# bind.*\)$" "# \1\nbind $RTDB_BIND"
  fi

  echo Checking network port... $RTDB_PORT
  if [ -n "$RTDB_PORT" ]; then
    echo Enabling network port $RTDB_PORT.
    replaceInFile $RTDB_DBDIR/$HOSTNAME/rethinkdb.conf "^\(# driver-port.*\)$" "# \1\nport $RTDB_PORT"
  fi

  return 0
}

function configureInstance() {

  return 0
}

function startInstance() {

  return 0
}

createInstanceDirectories && setupInstanceNetworking && \
 configureInstance && startInstance
