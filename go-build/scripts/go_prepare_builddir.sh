function go::prepareBuildDir() {

  BUILD_ID=$(uuidgen)
  SRC_DIR=/tmp/$BUILD_ID

  if [ -n "$GO_NS" ]; then
    SRC_DIR=$SRC_DIR/src/$GO_NS
  fi

  mkdir -p $SRC_DIR

  echo $SRC_DIR
}
