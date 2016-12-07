function sdk::prepareBuildDir() {

  BUILD_ID=$(uuidgen)
  SRC_DIR=/tmp/$BUILD_ID
  mkdir -p $SRC_DIR

  echo $SRC_DIR
}
