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
  cp -R /data/build/. /tmp/$BUILD_ID
fi

echo Cleanup obsolete files from temporary build directory...
rm -rf /tmp/$BUILD_ID/node_modules /tmp/$BUILD_ID/.git

if [ -f /tmp/$BUILD_ID/dependencies.lst ]; then
  echo Installing native dependencies...
  apk update
  MODULES=$(cat /tmp/$BUILD_ID/dependencies.lst | tr '\n' ' ')
  apk add $MODULES
  rm -rf /var/cache/apk/*
fi

cd /tmp/$BUILD_ID

if [ -f bower.json ]; then
  echo Installing Bower...
  npm i -g bower
  echo Running bower install in temporary build directory...
  bower install --allow-root
fi

if [ -f webpack.config.js ]; then
  echo Install webpack...
  npm i -g webpack
fi

if [ -f package.json ]; then
  echo Running npm install in temporary build directory...
  npm install --unsafe-perm && npm prune && npm cache clean
fi

if ls Gruntfile* 1> /dev/null 2>&1; then
  echo Installing Grunt...
  npm i -g grunt-cli
  echo Starting Grunt build process in temporary build directory...$@
  grunt $@
fi

if ls Gulpfile* 1> /dev/null 2>&1; then
  echo Installing Gulp...
  npm i -g gulp
  echo Starting Gulp build process in temporary build directory...$@
  gulp $@
fi

if [ -n "$PROJ_NAME" ]; then
  echo Generating Release $PROJ_NAME-$PROJ_VER-Release.tar.gz
  tar -czf /data/build/$PROJ_NAME-$PROJ_VER-Release.tar.gz .
fi

echo Finished.
