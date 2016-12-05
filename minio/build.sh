#!/bin/sh
# package build specifics
PKG_NS=github.com/minio/minio
PKG_NAME=minio
PKG_VER=0.1.0
PKG_MAIN=main.go

# runtime specifics
GO_VER=1.7
PROXY=
NO_PROXY=

if [ ! -f $PKG_NAME-$PKG_VER-Release.tar.gz ]; then
  echo Building Go binary...
  docker run --rm -e PROJ_NS=$PKG_NS -e PROJ_NAME=$PKG_NAME -e PROJ_VERS=$PKG_VER -e BUILD_ARGS=$PKG_MAIN -e http_proxy=$PROXY -e https_proxy=$PROXY -e no_proxy=$NO_PROXY -e GIT_REPO=github.com/minio/minio.git -v $(pwd):/data/src appelgriebsch/golang-build:$GO_VER
fi

echo Building Docker container...
if [ -f $PKG_NAME-$PKG_VER-Release.tar.gz ]; then
  mkdir -p ./dist
  tar -xzf $PKG_NAME-$PKG_VER-Release.tar.gz -C ./dist
  docker build --build-arg http_proxy=$PROXY --build-arg https_proxy=$PROXY --build-arg no_proxy=$NO_PROXY -t $PKG_NAME:$PKG_VER .
fi