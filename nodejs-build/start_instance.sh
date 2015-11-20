#!/bin/bash

echo Cleanup build directory...
rm -rf /data/build/.* /data/build/* 1> /dev/null 2>&1

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

if [ -f /data/build/bower.json ]; then
  echo Installing Bower...
  npm i -g bower

  bower install --allow-root
fi

if [ -f /data/src/webpack.config.js ]; then
  echo Install webpack...
  npm i -g webpack
fi

if [ -f /data/build/package.json ]; then
  echo Running npm install in build directory...
  npm install --unsafe-perm && npm prune && npm cache clean
fi

if ls /data/src/Gruntfile* 1> /dev/null 2>&1; then
  echo Installing Grunt...
  npm i -g grunt-cli

  echo Starting Grunt build process in build directory...
  grunt $@
fi

if ls dist/Gulpfile* 1> /dev/null 2>&1; then
  echo Installing Gulp...
  npm i -g gulp

  echo Starting Gulp build process in build directory...
  gulp $@
fi

echo Finished.
