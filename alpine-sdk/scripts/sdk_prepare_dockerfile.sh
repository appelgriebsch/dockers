function sdk::prepareDockerfile() {

  local SRC_DIR=$1
  local TM=$(date -Iminutes)

  if [ -f $1/Dockerfile.template ]; then
    cat $1/Dockerfile.template > /data/build/Dockerfile
    fs::replaceInFile /data/build/Dockerfile '$PROJ_NAME' "$PROJ_NAME"
    fs::replaceInFile /data/build/Dockerfile '$PROJ_VER' "$PROJ_VER"
    fs::replaceInFile /data/build/Dockerfile '$BUILD_TIME' "$TM"
  fi
}
