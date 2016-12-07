#!/bin/bash

for script in /tmp/scripts/*.sh; do
	. $script
done

SRC_DIR=$(go::prepareBuildDir)

function go::prepare() {
  sdk::prepareBuildEnv $SRC_DIR && \
      sdk::fetchSources $SRC_DIR && \
      fs::cleanupFolder $SRC_DIR '.git' && \
      os::installPkgs $SRC_DIR/devDependencies.lst
}

function go::build() {
  go::buildTarget $SRC_DIR
}

function go::package() {
  sdk::archiveTarget $SRC_DIR $PROJ_NAME
}

go::prepare && go::build && go::package
echo Finished.
