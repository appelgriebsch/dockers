function java::buildTarget() {

  local SRC_DIR=$1

  cd $SRC_DIR

  if [ -f pom.xml ]; then
    echo "Running mvn package in $SRC_DIR..."
    mvn package
  fi
}
