#!/bin/bash

BUILD_ID=$(uuidgen)
SRC_DIR=/tmp/$BUILD_ID

if [ -n "$PROJ_NS" ]; then
  echo Setting up project namespace $PROJ_NS
  SRC_DIR=$SRC_DIR/src/$PROJ_NS
fi

echo Creating temporary build directory $SRC_DIR
mkdir -p $SRC_DIR

if [ -n "$GIT_REPO" ]; then
  echo Cloning GIT repo from $GIT_REPO to $SRC_DIR
  if [ -n "$GIT_USER" ]; then
    git clone "https://$GIT_USER:$GIT_TOKEN@$GIT_REPO" $SRC_DIR
  else
    git clone "https://$GIT_REPO" $SRC_DIR
  fi
  if [ -n "$GIT_BRANCH" ]; then
    echo Checking out branch $GIT_BRANCH...
    cd $SRC_DIR
    git checkout -b $GIT_BRANCH origin/$GIT_BRANCH
  fi
  if [ -f $SRC_DIR/.gitmodules ]; then
    cd $SRC_DIR
    git submodules update --init
  fi
else
  echo Copy source files to build directory... $SRC_DIR
  cp -R /data/src/. $SRC_DIR
fi

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

export GOPATH=/tmp/$BUILD_ID

cd $SRC_DIR
go get -d
go build -o $PROJ_NAME $BUILD_ARGS

if [ -n "$PROJ_NAME" ]; then
  echo Generating Release $PROJ_NAME-$PROJ_VER-Release.tar.gz
  tar -czvf /data/src/$PROJ_NAME-$PROJ_VER-Release.tar.gz -C $SRC_DIR/ $PROJ_NAME
fi

echo Finished.
