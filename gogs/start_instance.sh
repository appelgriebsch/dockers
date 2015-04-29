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

  touch /opt/gogs/custom/conf/app.ini
  addToFile /opt/gogs/custom/conf/app.ini "# custom gogs configuration"
  addToFile /opt/gogs/custom/conf/app.ini "APP_NAME = Gogs - Self-hosted Git repositories"
  addToFile /opt/gogs/custom/conf/app.ini "RUN_MODE = prod"

  if [ -n "$GOGS_REPDIR" ]; then

    if ! [ -d "$GOGS_REPDIR" ]; then
       echo Creating repository path $GOGS_REPDIR.
       mkdir -p $GOGS_REPDIR
    fi

    echo Setting repository path to $GOGS_REPDIR.
    chown -R gogs:gogs $GOGS_REPDIR && \
    chmod -R 755 $GOGS_REPDIR
    addToFile /opt/gogs/custom/conf/app.ini "[repository]"
    addToFile /opt/gogs/custom/conf/app.ini "ROOT = $GOGS_REPDIR"
  fi

  return 0
}

function setupInstanceNetworking() {

  addToFile /opt/gogs/custom/conf/app.ini "[server]"
  addToFile /opt/gogs/custom/conf/app.ini "ENABLE_GZIP = true"

  echo Checking network binding... $GOGS_BIND
  addToFile /opt/gogs/custom/conf/app.ini "HTTP_ADDR = $GOGS_BIND"

  if [ -n "$GOGS_PORT" ]; then
    echo Checking network port... $GOGS_PORT
    addToFile /opt/gogs/custom/conf/app.ini "HTTP_PORT = $GOGS_PORT"
  fi

  return 0
}

function configureInstance() {

  echo Checking database type... $GOGS_DBTYPE

  if [ -n "$GOGS_DBTYPE" ]; then
    addToFile /opt/gogs/custom/conf/app.ini "[database]"
    addToFile /opt/gogs/custom/conf/app.ini "DB_TYPE = $GOGS_DBTYPE"

    addToFile /opt/gogs/custom/conf/app.ini "HOST = $GOGS_DBHOST"

    if [ "$GOGS_DBTYPE" == "sqlite3" ]; then
      addToFile /opt/gogs/custom/conf/app.ini "PATH = $GOGS_DBNAME"
    else
      addToFile /opt/gogs/custom/conf/app.ini "NAME = $GOGS_DBNAME"
    fi
  fi

  if [ -n "$GOGS_SECRET" ]; then
    echo Setting up secret token...
    addToFile /opt/gogs/custom/conf/app.ini "[security]"
    addToFile /opt/gogs/custom/conf/app.ini "SECRET_KEY = $GOGS_SECRET"
  fi

  if [ -n "$GOGS_LOGLVL" ]; then
    echo Setting up log-level...$GOGS_LOGLVL
    addToFile /opt/gogs/custom/conf/app.ini "[log]"
    addToFile /opt/gogs/custom/conf/app.ini "MODE = console"
    addToFile /opt/gogs/custom/conf/app.ini "LEVEL = $GOGS_LOGLVL"
  fi

  return 0
}

function startInstance() {

  gogs run web
  return 0
}

createInstanceDirectories && setupInstanceNetworking && \
 configureInstance && startInstance
