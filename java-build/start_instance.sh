#!/bin/bash

BUILD_ID=$(uuidgen)
SRC_DIR=/tmp/$BUILD_ID

echo Creating temporary build directory $SRC_DIR
mkdir -p $SRC_DIR

if [ -n "$GIT_REPO" ]; then
  echo Cloning GIT repo from $GIT_REPO to $SRC_DIR

  if [ -n "$GIT_USER" ]; then
    git clone "https://$GIT_USER:$GIT_TOKEN@$GIT_REPO" $SRC_DIR
  else
    git clone "https://$GIT_REPO" $SRC_DIR
  fi
  if [ -f $SRC_DIR/.gitmodules ]; then
    cd $SRC_DIR
    git submodules update --init
  fi
else
  echo Copy source files to build directory... $SRC_DIR
  cp -R /data/src/. $SRC_DIR
fi

echo Cleanup obsolete files from temporary build directory...
rm -rf $SRC_DIR/.git

echo Checking for dev dependencies....
if [ -f $SRC_DIR/devDependencies.lst ]; then
  echo Installing native dev dependencies...
  apk update
  MODULES=$(cat $SRC_DIR/devDependencies.lst | tr '\n' ' ')
  apk add $MODULES
  rm -rf /var/cache/apk/*
fi

echo Preparing build environment...
if [ -f $SRC_DIR/prepare_env.sh ]; then
  echo Setting up build environment...
  cat $SRC_DIR/prepare_env.sh
  chmod 755 $SRC_DIR/prepare_env.sh
  $SRC_DIR/prepare_env.sh
fi

cd $SRC_DIR

if [ -f pom.xml ]; then
  echo Running mvn package in temporary build directory...
  mvn package
fi

if [ -n "$PROJ_NAME" ]; then
  echo Generating Release $PROJ_NAME-$PROJ_VER-Release.tar.gz
  tar -czvf /data/src/$PROJ_NAME-$PROJ_VER-Release.tar.gz -C $SRC_DIR/ .
fi

echo Finished.
