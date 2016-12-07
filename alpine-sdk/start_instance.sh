#!/bin/bash

for script in /tmp/scripts/*.sh; do
	. $script
done

function sdk::build() {

	local SRC_DIR=$(sdk::prepareBuildDir)

	sdk::prepareBuildEnv $SRC_DIR && \
		sdk::retrieveSources $SRC_DIR && \
		sdk::cleanupBuildFolder $SRC_DIR '.git' && \
		sdk::installDevDependencies $SRC_DIR && \
		sdk::buildTarget $SRC_DIR && \
		sdk::archiveTarget $SRC_DIR/dist '.'
}

sdk::build
echo Finished.
