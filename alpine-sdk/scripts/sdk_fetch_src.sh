function sdk::fetchSources() {

  local SRC_DIR=$1

  if [ -n "$GIT_REPO" ]; then
    echo "Cloning GIT repo from $GIT_REPO to $SRC_DIR"

    if [ -n "$GIT_USER" ]; then
      git clone "https://$GIT_USER:$GIT_TOKEN@$GIT_REPO" $SRC_DIR
    else
      git clone "https://$GIT_REPO" $SRC_DIR
    fi

    if [ -n "$GIT_BRANCH" ]; then
      echo "Checking out branch $GIT_BRANCH..."
      cd $SRC_DIR
      git checkout -b $GIT_BRANCH origin/$GIT_BRANCH
    fi

    if [ -f $SRC_DIR/.gitmodules ]; then
      cd $SRC_DIR
      git submodules update --init
    fi
  fi

  echo "Copy additional files to build directory... $SRC_DIR"
  cp -R /data/build/. $SRC_DIR

  return $?
}
