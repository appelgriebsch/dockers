function sdk::prepareDockerfile() {

  local SRC_DIR=$1
  local TM=$(date -Iminutes)

  if [ -f $1/Dockerfile.template ]; then
    cat $1/Dockerfile.template > $1/Dockerfile
    fs::replaceInFile $1/Dockerfile '$PROJ_NAME' "$PROJ_NAME"
    fs::replaceInFile $1/Dockerfile '$PROJ_VER' "$PROJ_VER"
    fs::replaceInFile $1/Dockerfile '$BUILD_TIME' "$TM"
  fi
}
