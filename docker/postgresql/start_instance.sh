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

  if [ -n "$PGSQL_DBDIR" ]; then
    echo Creating database path $PGSQL_DBDIR/$HOSTNAME.
    mkdir -p $PGSQL_DBDIR/$HOSTNAME
  fi

  echo Setting database path to $PGSQL_DBDIR.
  chown -R postgres:postgres $PGSQL_DBDIR && \
  chmod -R 755 $PGSQL_DBDIR/$HOSTNAME
  /usr/pgsql-9.3/bin/initdb -D $PGSQL_DBDIR/$HOSTNAME -E UTF-8

  return 0
}

function setupInstanceNetworking() {

  echo Checking network binding... $PGSQL_BIND
  if [ "$PGSQL_BIND" == "127.0.0.1" ]; then
    echo Disable public network binding, connection has to take place via unix socket...
    replaceInFile $PGSQL_DBDIR/$HOSTNAME/postgresql.conf "^\(#unix_socket_directories.*\)$" "\1\nunix_socket_directories = '$PGSQL_DBDIR/$HOSTNAME'"
    replaceInFile $PGSQL_DBDIR/$HOSTNAME/postgresql.conf "^\(#unix_socket_group.*\)$" "\1\nunix_socket_group = 'postgres'"
    replaceInFile $PGSQL_DBDIR/$HOSTNAME/postgresql.conf "^\(#unix_socket_permissions.*\)$" "\1\nunix_socket_permissions = '0755'"
    addToFile $PGSQL_DBDIR/$HOSTNAME/pg_hba.conf "local all all md5"
  else
    echo Enabling network binding on IP $PGSQL_BIND.
    replaceInFile $PGSQL_DBDIR/$HOSTNAME/postgresql.conf "^\(#listen_addresses.*\)$/listen_addresses = '$PGSQL_BIND'\n\1/"
    addToFile $PGSQL_DBDIR/$HOSTNAME/pg_hba.conf "host all  all    $PGSQL_BIND  md5"
  fi

  echo Checking network port... $PGSQL_PORT
  if [ -n "$PGSQL_PORT" ]; then
    echo Enabling network port $PGSQL_PORT.
    replaceInFile $PGSQL_DBDIR/$HOSTNAME/postgresql.conf "s/^\(#port.*\)$" "\1\nport = $PGSQL_PORT"
  fi

  return 0
}

function configureInstance() {

  echo Checking database user settings...
  if [ -n "$PGSQL_DBADMIN" ]; then
    DBUSR=$(replaceInString $PGSQL_DBADMIN "^\([0-9A-Za-z._\-]*\):\([0-9]*\)$" "\1")
    DBPWD=$(replaceInString $PGSQL_DBADMIN "^\([0-9A-Za-z._\-]*\):\([0-9]*\)$" "\2")

    addToFile /tmp/initInstance.sql "// initialize and configure database instance"
    addToFile /tmp/initInstance.sql "CREATE ROLE $DBUSR PASSWORD '$DBPWD' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN;"
    addToFile /tmp/initInstance.sql "CREATE DATABASE $PGSQL_DBNAME OWNER $DBUSR;"
  fi
  echo Checking database log level... $PGSQL_LOGLVL
  if [ -n "$PGSQL_LOGLVL" ]; then
    replaceInFile $PGSQL_DBDIR/$HOSTNAME/postgresql.conf "^\(#log_min_messages .*\)$" "\1\nlog_min_messages = $PGSQL_LOGLVL"
  fi
}

function startInstance() {

  INSTANCE_CMD="/usr/pgsql-9.3/bin/postgres -D $PGSQL_DBDIR/$HOSTNAME"

  if [ -f /tmp/initInstance.sql ]; then
    echo Local configuration script found. Starting instance in background...
    # Turn on monitor mode to allow switching between background and foreground processes
    set -m
    $INSTANCE_CMD &
    # wait for connection to MASTER server and LOCALHOST
    waitForConnection 127.0.0.1 $PGSQL_PORT
    echo Executing local configuration script on server 127.0.0.1:$PGSQL_PORT
    initStatus=$(/usr/pgsql-9.3/bin/psql --file=/tmp/initInstance.sql)
    echo Initialize status: $initStatus
    fg %1
  else
    $INSTANCE_CMD
  fi

  return 0
}

createInstanceDirectories && setupInstanceNetworking && \
 configureInstance && startInstance
