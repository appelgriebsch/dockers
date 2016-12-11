#!/bin/sh

EXEC="$GO_APPDIR/minio"
CONF="$GO_APPDIR/.minio"

if [ "$#" == "0" ]; then
  "${EXEC}" "--config-dir" "$CONF" "--help"
else
  "${EXEC}" "--config-dir" "$CONF" "$@"
fi
