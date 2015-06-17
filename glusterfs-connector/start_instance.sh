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

function waitForDaemon() {

  TEST_CMD="gluster pool list"

  $TEST_CMD

  while [ $? -ne 0 ]; do

    sleep 10

    # exec test command
    $TEST_CMD

  done
}

function createInstanceDirectories() {

  if [ -n "$GLUSTER_DIR" ]; then
    echo Creating GlusterFS path $GLUSTER_DIR.
    mkdir -p $GLUSTER_DIR/$GLUSTER_VOLUME
  fi

  echo Setting GlusterFS path to $GLUSTER_DIR.
  chmod -R 755 $GLUSTER_DIR/$GLUSTER_VOLUME
  return 0
}

function setupInstanceNetworking() {

  return 0
}

function configureInstance() {

  echo Checking Gluster Node....$GLUSTER_NODE
  local peerIP=$(resolveIPAddress $GLUSTER_NODE)

  mount -t glusterfs $peerIP:/$GLUSTER_VOLUME $GLUSTER_DIR/$GLUSTER_VOLUME

  return 0
}

function startInstance() {

  exec "$@"
  return 0
}

createInstanceDirectories && setupInstanceNetworking && \
 configureInstance && startInstance
