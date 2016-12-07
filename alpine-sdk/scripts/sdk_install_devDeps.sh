function sdk::installDevDependencies() {

  local SRC_DIR=$1

  if [ -f $SRC_DIR/devDependencies.lst ]; then

    apk update
    MODULES=$(cat $SRC_DIR/devDependencies.lst | tr '\n' ' ')

    echo "Installing native dev dependencies...$MODULES"
    apk add $MODULES
    rm -rf /var/cache/apk/*

  fi

  return $?
}
