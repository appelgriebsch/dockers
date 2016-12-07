function sdk::prepareBuildEnv() {

  local SRC_DIR=$1

  if [ -f $SRC_DIR/build_env.sh ]; then
    echo "Setting up build environment...$SRC_DIR"
    cat $SRC_DIR/build_env.sh
    sh -c "$SRC_DIR/build_env.sh"
  fi

  return $?
}
