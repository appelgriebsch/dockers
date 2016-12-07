function sdk::archiveTarget() {

  local SRC_DIR=$1
  local TARGET=$2

  if [ -n "$PROJ_NAME" ]; then
    echo "Generating Release $PROJ_NAME-$PROJ_VER-Release.tar.gz"
    tar -czvf /data/build/$PROJ_NAME-$PROJ_VER-Release.tar.gz -C $SRC_DIR/ $TARGET
  fi

  return $?
}
