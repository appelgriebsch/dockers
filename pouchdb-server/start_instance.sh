#!/bin/bash

function createInstanceDirectories() {
  return 0
}

function setupInstanceNetworking() {

  return 0
}

function configureInstance() {

  return 0
}

function startInstance() {

  DB_DRIVER=""

  if [ "$POUCHDB_DRIVER" == "sqlite" ]; then
    DB_DRIVER="--sqlite"
  fi

  $NODEJS_APPDIR/bin/pouchdb-server --dir=/data/pouchdb --port=$POUCHDB_PORT --host=$POUCHDB_BIND $DB_DRIVER
  return 0
}

createInstanceDirectories && setupInstanceNetworking && \
 configureInstance && startInstance
