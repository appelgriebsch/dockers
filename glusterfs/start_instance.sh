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
    echo Creating GlusterFS path $GLUSTER_DIR/$HOSTNAME.
    mkdir -p $GLUSTER_DIR/$HOSTNAME
  fi

  echo Setting GlusterFS path to $GLUSTER_DIR/$HOSTNAME.
  chmod -R 755 $GLUSTER_DIR/$HOSTNAME
  return 0
}

function setupInstanceNetworking() {

  return 0
}

function configureInstance() {

  IMAGE_FILE=$GLUSTER_DIR/$HOSTNAME.img

  echo Creating Image $IMAGE_FILE with size $IMAGE_SIZE
  touch $IMAGE_FILE
  dd if=/dev/zero of=$IMAGE_FILE bs=$IMAGE_SIZE count=1
  mkfs.xfs $IMAGE_FILE

  echo Mounting $IMAGE_FILE to $GLUSTER_DIR/$HOSTNAME
  mount -t xfs -o loop $IMAGE_FILE $GLUSTER_DIR/$HOSTNAME

  addToFile /tmp/initInstance.sh "#!/bin/bash"

  if [ -n "$GLUSTER_PEER" ]; then
    addToFile /tmp/initInstance.sh "gluster peer probe $GLUSTER_PEER"
  fi

  STRIPE_CONF=""
  if [ -n "$STRIPE_CNT" ]; then
    STRIPE_CONF="stripe $STRIPE_CNT"
  fi

  REPLICA_CONF=""
  if [ -n "$REPLICA_CNT" ]; then
    REPLICA_CONF="replica $REPLICA_CNT"
  fi

  echo Create brick...$BRICK_NAME
  mkdir -p $GLUSTER_DIR/$HOSTNAME/$BRICK_NAME

  echo Create volume...$VOLUME_NAME
  mkdir -p $GLUSTER_DIR/$HOSTNAME/$BRICK_NAME/$VOLUME_NAME
  addToFile /tmp/initInstance.sh "volStatus=\$(gluster volume info $VOLUME_NAME)"
  addToFile /tmp/initInstance.sh "if [ \$? -ne 0 ]; then"
  addToFile /tmp/initInstance.sh "echo \$volStatus"
  addToFile /tmp/initInstance.sh "gluster volume create $VOLUME_NAME $STRIPE_CONF $REPLICA_CONF transport tcp $HOSTNAME:$GLUSTER_DIR/$HOSTNAME/$BRICK_NAME/$VOLUME_NAME force"
  addToFile /tmp/initInstance.sh "gluster volume start $VOLUME_NAME"
  addToFile /tmp/initInstance.sh "else"
  addToFile /tmp/initInstance.sh "gluster volume add-brick $VOLUME_NAME $STRIPE_CONF $REPLICA_CONF $HOSTNAME:$GLUSTER_DIR/$HOSTNAME/$BRICK_NAME/$VOLUME_NAME"
  addToFile /tmp/initInstance.sh "gluster volume rebalance $VOLUME_NAME start"
  addToFile /tmp/initInstance.sh "fi"
  return 0
}

function startInstance() {

  INSTANCE_CMD="glusterd --no-daemon --selinux -l /dev/stdout"

  if [ -f /tmp/initInstance.sh ]; then

    echo Local configuration script found. Starting instance in background...
    # Turn on monitor mode to allow switching between background and foreground processes
    set -m
    $INSTANCE_CMD &

    # wait for daemon to start
    waitForDaemon

    echo Executing local configuration script on server 127.0.0.1
    chmod 755 /tmp/initInstance.sh
    initStatus=$(/tmp/initInstance.sh)

    echo Initialize status: $initStatus
    fg %1
  else
    $INSTANCE_CMD
  fi
  return 0
}

createInstanceDirectories && setupInstanceNetworking && \
 configureInstance && startInstance
