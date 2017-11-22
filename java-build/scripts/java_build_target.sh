function java::buildTarget() {

  local SRC_DIR=$1

  cd $SRC_DIR

  if [ -f pom.xml ]; then
    echo "Running mvn package in $SRC_DIR..."
    mvn package
  elif [ -f build.gradle ]; then
    echo "Running gradle bootRepackage in $SRC_DIR..."
    gradle bootRepackage
    mkdir $SRC_DIR/target
    cp $SRC_DIR/build/libs/*.jar $SRC_DIR/target/
  fi
}
