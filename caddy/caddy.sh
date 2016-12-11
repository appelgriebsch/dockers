#!/bin/sh

EXEC="$GO_APPDIR/caddy"
CONF="$CADDY_SITEDIR/Caddyfile"

if [ "$#" == "0" ]; then
  "${EXEC}" "--help"
else
  "${EXEC}" "-conf=$CADDY_SITEDIR/Caddyfile" "-host=$HOST" "-port=$PORT" \
      "-agree" "-log=stdout" "-root=$CADDY_SITEDIR/site" "$@"
fi
