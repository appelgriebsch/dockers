#!/bin/bash

for script in /tmp/scripts/*.sh; do
	. $script
done

SRC_DIR=$(sdk::prepareBuildDir)

function java::prepare() {
  sdk::prepareBuildEnv $SRC_DIR && \
      sdk::fetchSources $SRC_DIR && \
      fs::cleanupFolder $SRC_DIR '.git' && \
      os::installPkgs $SRC_DIR/devDependencies.lst
}

function java::build() {
  java::buildTarget $SRC_DIR
}

function java::package() {
  sdk::archiveTarget $SRC_DIR/target .
}

java::prepare && java::build && java::package
echo Finished.
