#!/bin/bash

if [ -f $NODEJS_APPDIR/dependencies.lst ]; then
  echo Installing native dependencies...
  apk update
  MODULES=$(cat $NODEJS_APPDIR/dependencies.lst | tr '\n' ' ')
  apk add $MODULES
  rm -rf /var/cache/apk/*
fi
