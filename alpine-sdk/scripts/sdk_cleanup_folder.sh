function sdk::cleanupBuildFolder() {

  local SRC_DIR=$1
  local FILES=$2

  echo "Cleanup obsolete files $FILES from temporary build directory $SRC_DIR..."
  rm -rf $SRC_DIR/{$FILES}

  return $?
}
