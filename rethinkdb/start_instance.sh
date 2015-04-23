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

  if [ -n "$RETHDB_DBDIR" ]; then

    if ! [ -d "$RETHDB_DBDIR/$HOSTNAME" ]; then
       echo Creating database path $RETHDB_DBDIR/$HOSTNAME.
       mkdir -p $RETHDB_DBDIR/$HOSTNAME
    fi

    echo Setting database path to $RETHDB_DBDIR.
    cp /etc/rethinkdb/default.conf.sample $RETHDB_DBDIR/$HOSTNAME/rethinkdb.conf && \
    chown -R rethinkdb:rethinkdb $RETHDB_DBDIR && \
    chmod -R 755 $RETHDB_DBDIR/$HOSTNAME
    dbpath=$(maskPath $RETHDB_DBDIR/$HOSTNAME)
    replaceInFile $RETHDB_DBDIR/$HOSTNAME/rethinkdb.conf "^\(directory.*\)$" "directory=$dbpath"
  fi

  return 0
}

function setupInstanceNetworking() {

  echo Checking network binding... $RETHDB_BIND

  if [ "$RETHDB_BIND" == "127.0.0.1" ]; then
    echo Disable public network binding, connection has to take place via unix socket...
    socketpath=$(maskPath $RETHDB_DBDIR/$HOSTNAME)
  else
    echo Enabling network binding on IP $RETHDB_BIND.
    replaceInFile $RETHDB_DBDIR/$HOSTNAME/rethinkdb.conf "^\(# bind.*\)$" "# \1\nbind $RETHDB_BIND"
  fi

  echo Checking network port... $RETHDB_PORT
  if [ -n "$RETHDB_PORT" ]; then
    echo Enabling network port $RETHDB_PORT.
    replaceInFile $RETHDB_DBDIR/$HOSTNAME/rethinkdb.conf "^\(# driver-port.*\)$" "# \1\nport $RETHDB_PORT"
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
