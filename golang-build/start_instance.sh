#!/bin/bash

BUILD_ID=$(uuidgen)

echo Creating temporary build directory /tmp/$BUILD_ID
mkdir -p /tmp/$BUILD_ID

if [ -n "$GIT_REPO" ]; then
  echo Cloning GIT repo from $GIT_REPO

  if [ -n "$GIT_USER" ]; then
    git clone "https://$GIT_USER:$GIT_TOKEN@$GIT_REPO" /tmp/$BUILD_ID
  else
    git clone "https://$GIT_REPO" /tmp/$BUILD_ID
  fi
else
  echo Copy source files to build directory...
  cp -R /data/src/. /tmp/$BUILD_ID
fi

echo Cleanup obsolete files from temporary build directory...
rm -rf /tmp/$BUILD_ID/.git

if [ -f /tmp/$BUILD_ID/devDependencies.lst ]; then
  echo Installing native dev dependencies...
  apk update
  MODULES=$(cat /tmp/$BUILD_ID/devDependencies.lst | tr '\n' ' ')
  apk add $MODULES
  rm -rf /var/cache/apk/*
fi

cd /tmp/$BUILD_ID
export GOPATH=$(pwd)
go get -d
go build -o $PROJ_NAME $BUILD_ARGS

if [ -n "$PROJ_NAME" ]; then
  echo Generating Release $PROJ_NAME-$PROJ_VER-Release.tar.gz
  tar -czf /data/src/$PROJ_NAME-$PROJ_VER-Release.tar.gz .
fi

echo Finished.
