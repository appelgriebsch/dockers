function sdk::buildTarget() {

  local SRC_DIR=$1

  cd $SRC_DIR

  echo "Building module $PROJ_NAME v$PROJ_VER in $SRC_DIR"

  if [ -f './autogen.sh' ]; then
    sh -c "./autogen.sh"
  fi

  if [ -f './configure' ]; then
    ./configure --prefix=$SRC_DIR/dist $BUILD_ARGS
  fi

  if [ -f './Makefile' ]; then
    PREFIX=$SRC_DIR/dist make &&
      PREFIX=$SRC_DIR/dist make install
  fi

  return $?
}
