function go::setGoPath() {

  local SRC_DIR=$1
  local GOPATH=$SRC_DIR

  if [ -n "$GO_NS" ]; then
     GO_NS_PATH=$(fs::maskPath "/src/$GO_NS")
     GOPATH=$(fs::replaceInString $SRC_DIR $GO_NS_PATH "")
  fi

  echo $GOPATH
}
