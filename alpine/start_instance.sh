#!/bin/bash

for script in /tmp/scripts/*.sh; do
	. $script
done

HOST=$(net::hostName)

echo -e 'Host:\t' $HOST
echo -e 'IP:\t' $(net::resolveIPAddress $HOST)
echo -e 'OS:\t' $(os::version) release $(os::release) on $(os::arch)

EXEC=$1
shift
echo "Booting up....$EXEC"
${EXEC} "$@"
