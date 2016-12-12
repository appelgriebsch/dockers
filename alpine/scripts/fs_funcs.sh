function fs::replaceInFile() {

  local file=$1
  local searchFor=$2
  local replaceWith=$3

  sed -i "s/$searchFor/$replaceWith/g" $file
}

function fs::addToFile() {

  local file=$1
  local line=$2

  echo $2 >> $1
}

function fs::replaceInString() {

  local origString=$1
  local searchFor=$2
  local replaceWith=$3

  echo $(echo $origString | sed -e "s/$searchFor/$replaceWith/g")
}

function fs::maskPath() {

  local path=$1
  local pathDelimiter="\/"
  local replacementPattern="\\\\\/"

  echo $(fs::replaceInString $path $pathDelimiter $replacementPattern)
}

function fs::cleanupFolder() {

  local SRC_DIR=$1
  local FILES=$2

  echo "Cleanup obsolete files $FILES from temporary build directory $SRC_DIR..."
  rm -rf $SRC_DIR/{$FILES}

  return $?
}
