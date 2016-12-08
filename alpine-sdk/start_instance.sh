#!/bin/bash

for script in /tmp/scripts/*.sh; do
	. $script
done

SRC_DIR=$(sdk::prepareBuildDir)

function sdk::prepare() {
  sdk::fetchSources $SRC_DIR && \
		sdk::prepareBuildEnv $SRC_DIR && \
    os::installPkgs $SRC_DIR/devDependencies.lst
}

function sdk::build() {
  sdk::buildTarget $SRC_DIR
}

function sdk::package() {
	fs::cleanupFolder $SRC_DIR '.git' && \
  	sdk::archiveTarget $SRC_DIR/dist '.' && \
		sdk::prepareDockerfile $SRC_DIR
}

echo Starting native binary build...$PROJ_NAME $PROJ_VER
sdk::prepare && sdk::build && sdk::package
echo Finished.
