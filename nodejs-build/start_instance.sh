#!/bin/bash

for script in /tmp/scripts/*.sh; do
	. $script
done

SRC_DIR=$(sdk::prepareBuildDir)

function nodejs::prepare() {
  sdk::prepareBuildEnv $SRC_DIR && \
      sdk::fetchSources $SRC_DIR && \
      fs::cleanupFolder $SRC_DIR '.git,node_modules' && \
      os::installPkgs $SRC_DIR/devDependencies.lst
}

function nodejs::build() {
  nodejs::buildTarget $SRC_DIR
}

function nodejs::package() {
  sdk::archiveTarget $SRC_DIR .
}

nodejs::prepare && nodejs::build && nodejs::package
echo Finished.
