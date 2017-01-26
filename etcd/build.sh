#!/bin/sh
# package build specifics
GO_NS=github.com/coreos/etcd
PKG_NAME=etcd
PKG_VER=3.1.0
PKG_MAIN=main.go

# Git repo settings
GIT_REPO=github.com/coreos/etcd.git
GIT_BRANCH=release-3.1

# runtime specifics
GO_VER=1.7
PROXY=
NO_PROXY=

if [ ! -f $PKG_NAME-$PKG_VER-Release.tar.gz ]; then
  docker run --rm -e GO_NS=$GO_NS -e PROJ_NAME=$PKG_NAME -e PROJ_VER=$PKG_VER -e BUILD_ARGS=$PKG_MAIN -e http_proxy=$PROXY -e https_proxy=$PROXY -e no_proxy=$NO_PROXY -e GIT_REPO=$GIT_REPO -e GIT_BRANCH=$GIT_BRANCH -v $(pwd):/data/build appelgriebsch/go-build:$GO_VER
fi

if [ -f $PKG_NAME-$PKG_VER-Release.tar.gz ]; then
  echo Building Docker container...
  mkdir -p ./dist
  tar -xzf $PKG_NAME-$PKG_VER-Release.tar.gz -C ./dist
  docker build --build-arg http_proxy=$PROXY --build-arg https_proxy=$PROXY --build-arg no_proxy=$NO_PROXY -t $PKG_NAME:$PKG_VER .
fi
