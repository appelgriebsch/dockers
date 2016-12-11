#!/bin/sh

EXEC="$GO_APPDIR/etcd"

if [ "$#" == "0" ]; then
  "${EXEC}" "--help"
else
  "${EXEC}" "$@"
fi
