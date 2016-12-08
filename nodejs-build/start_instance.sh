#!/bin/bash

for script in /tmp/scripts/*.sh; do
	. $script
done

SRC_DIR=$(sdk::prepareBuildDir)

function nodejs::prepare() {
	sdk::fetchSources $SRC_DIR && \
  	sdk::prepareBuildEnv $SRC_DIR && \
    os::installPkgs $SRC_DIR/devDependencies.lst
}

function nodejs::build() {
  nodejs::buildTarget $SRC_DIR
}

function nodejs::package() {
	fs::cleanupFolder $SRC_DIR '.git' && \
		sdk::archiveTarget $SRC_DIR . && \
		sdk::prepareDockerfile $SRC_DIR
}

nodejs::prepare && nodejs::build && nodejs::package
echo Finished.
