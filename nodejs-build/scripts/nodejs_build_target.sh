function nodejs::buildTarget() {

  local SRC_DIR=$1

  cd $SRC_DIR

  if [ -f bower.json ]; then
    echo "Installing Bower..."
    npm i -g bower
    echo "Running bower install in $SRC_DIR..."
    bower install --allow-root
  fi

  if [ -f package.json ]; then
    echo "Running npm install in $SRC_DIR..."
    npm install --unsafe-perm && npm prune && npm cache clean
    echo "Starting npm build process..."
    npm run build -- $BUILD_ARGS
  fi
}
