#!/bin/bash

for script in /tmp/scripts/*.sh; do
	. $script
done

if [ -f /tmp/dependencies.lst ]; then
	os::installPkgs /tmp/dependencies.lst
fi

echo Done.
