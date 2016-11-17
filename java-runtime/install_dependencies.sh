#!/bin/bash

if [ -f $JAVA_APPDIR/dependencies.lst ]; then
  echo Installing native dependencies...
  apk update
  MODULES=$(cat $JAVA_APPDIR/dependencies.lst | tr '\n' ' ')
  apk add $MODULES
  rm -rf /var/cache/apk/*
fi