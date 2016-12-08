#!/bin/bash

for script in /tmp/scripts/*.sh; do
	. $script
done

SRC_DIR=$(sdk::prepareBuildDir)

function java::prepare() {
	sdk::fetchSources $SRC_DIR && \
  	sdk::prepareBuildEnv $SRC_DIR && \
    os::installPkgs $SRC_DIR/devDependencies.lst
}

function java::build() {
  java::buildTarget $SRC_DIR
}

function java::package() {
	fs::cleanupFolder $SRC_DIR '.git' && \
		sdk::archiveTarget $SRC_DIR/target . && \
		sdk::prepareDockerfile $SRC_DIR
}

echo Starting Java build...$PROJ_NAME $PROJ_VER
java::prepare && java::build && java::package
echo Finished.
