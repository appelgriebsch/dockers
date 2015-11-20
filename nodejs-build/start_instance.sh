#!/bin/bash

if [ -f /data/src/bower.json ]; then
  echo Installing Bower...
  npm i -g bower
fi

if ls /data/src/Gruntfile* 1> /dev/null 2>&1; then
  echo Installing Grunt...
  npm i -g grunt-cli
fi

if ls dist/Gulpfile* 1> /dev/null 2>&1; then
  echo Installing Gulp...
  npm i -g gulp
fi

if [ -f /data/src/webpack.config.js ]; then
  echo Install webpack...
  npm i -g webpack
fi

echo Cleanup build directory...
rm -rf /data/build/*

echo Copy source files to build directory...
cp -R /data/src/. /data/build

echo Cleanup obsolete files from build directory...
rm -rf /data/build/node_modules /data/build/.git

if [ -f /data/build/dependencies.lst ]; then
  echo Installing native dependencies...
  apk update
  MODULES=$(cat /data/build/dependencies.lst | tr '\n' ' ')
  apk add $MODULES
  rm -rf /var/cache/apk/*
fi

if [ -f /data/build/package.json ]; then
  echo Running npm install in build directory...
  npm install && npm prune
  npm cache clean
fi

if [ -f /data/build/Gruntfile ]; then
  echo Starting Grunt build process in build directory...
  grunt-cli $@
fi

if [ -f /data/build/Gulpfile ]; then
  echo Starting Gulp build process in build directory...
  gulp $@
fi

echo Finished.
