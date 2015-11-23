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

  $NODEJS_APPDIR/bin/pouchdb-server --dir=/data/pouchdb --port=$POUCHDB_PORT --host=$POUCHDB_BIND
  return 0
}

createInstanceDirectories && setupInstanceNetworking && \
 configureInstance && startInstance
