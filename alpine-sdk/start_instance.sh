#!/bin/bash

for script in /tmp/scripts/*.sh; do
	. $script
done

SRC_DIR=$(sdk::prepareBuildDir)

function sdk::prepare() {
  sdk::prepareBuildEnv $SRC_DIR && \
      sdk::fetchSources $SRC_DIR && \
      fs::cleanupFolder $SRC_DIR '.git' && \
      os::installPkgs $SRC_DIR/devDependencies.lst
}

function sdk::build() {
  sdk::buildTarget $SRC_DIR
}

function sdk::package() {
  sdk::archiveTarget $SRC_DIR/dist '.'
}

sdk::prepare && sdk::build && sdk::package
echo Finished.
