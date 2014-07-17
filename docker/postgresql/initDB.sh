#!/bin/bash

echo Initialize the database...
/usr/pgsql-9.3/bin/initdb -D /data/postgresql -E UTF-8
sed -i "s/^\(#listen_addresses.*\)$/listen_addresses = '*'\n\1/" /data/postgresql/postgresql.conf
echo "host all  all    0.0.0.0/0  md5" >> /data/postgresql/pg_hba.conf

echo Start the database server...
/usr/pgsql-9.3/bin/postgres -D /data/postgresql &
PGID=$!

echo Creating database user...
DBUSR=dbUser
DBPWD=md5$(echo "!dbUseR!" | md5sum)
sleep 2 
/usr/pgsql-9.3/bin/psql --command="CREATE ROLE \"$DBUSR\" PASSWORD '\"$DBPWD\"' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN;"

echo Stopping the database server...
sleep 2 
kill $PGID
