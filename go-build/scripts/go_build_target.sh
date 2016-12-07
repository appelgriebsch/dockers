function go::buildTarget() {

  local SRC_DIR=$1

  export GOPATH=/tmp/$BUILD_ID

  cd $SRC_DIR
  go get -d
  go build -o $PROJ_NAME $BUILD_ARGS
}
