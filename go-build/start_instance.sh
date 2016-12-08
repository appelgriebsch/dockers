#!/bin/bash

for script in /tmp/scripts/*.sh; do
	. $script
done

SRC_DIR=$(go::prepareBuildDir)

function go::prepare() {
  sdk::fetchSources $SRC_DIR && \
		sdk::prepareBuildEnv $SRC_DIR && \
    os::installPkgs $SRC_DIR/devDependencies.lst
}

function go::build() {
  go::buildTarget $SRC_DIR
}

function go::package() {
	fs::cleanupFolder $SRC_DIR '.git' && \
  	sdk::archiveTarget $SRC_DIR $PROJ_NAME && \
		sdk::prepareDockerfile $SRC_DIR
}

echo Starting Go binary build...$PROJ_NAME $PROJ_VER
go::prepare && go::build && go::package
echo Finished.
