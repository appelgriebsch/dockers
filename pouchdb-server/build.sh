#!/bin/bash

docker run --rm -e GIT_REPO="github.com/appelgriebsch/pouchdb-server.git" \
                -e PROJ_NAME="pouchdb-server" -e PROJ_VER="1.1.1" \
                -e HTTP_PROXY=$HTTP_PROXY -e HTTPS_PROXY=$HTTPS_PROXY \
                -v /tmp/build:/data/build:Z appelgriebsch/nodejs-build

if [ -f '/tmp/build/pouchdb-server-1.1.1-Release.tar.gz' ]; then
  cd $PWD/dist/ && \
  tar -xzf /tmp/build/pouchdb-server*.tar.gz && \
  docker build --tag="appelgriebsch/pouchdb-server:1.1.1" $PWD/..
fi
