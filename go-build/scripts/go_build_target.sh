function go::buildTarget() {

  local SRC_DIR=$1

  cd $SRC_DIR

  if [ -f $SRC_DIR/glide.yaml ]; then
    echo Installing dependencies...
    glide install -v
  fi

  go get -d
  go build -o $PROJ_NAME $BUILD_ARGS
}
