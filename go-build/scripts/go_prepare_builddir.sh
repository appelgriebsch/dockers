function go::prepareBuildDir() {

  BUILD_ID=$(uuidgen)
  SRC_DIR=/tmp/$BUILD_ID

  if [ -n "$PROJ_NS" ]; then
    SRC_DIR=$SRC_DIR/src/$PROJ_NS
  fi

  mkdir -p $SRC_DIR

  echo $SRC_DIR
}
