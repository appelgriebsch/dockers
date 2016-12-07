function os::release() {
  OS_REL=$(uname -r)
  echo $OS_REL
}

function os::version() {
  OS_VER=$(uname -o)
  echo $OS_VER
}

function os::arch() {
  OS_ARCH=$(uname -m)
  echo $OS_ARCH
}

function os::installPkgs() {

  local PKG_LIST=$1

  if [ -f $PKG_LIST ]; then
    apk update
    MODULES=$(cat $PKG_LIST | tr '\n' ' ')
    echo "Installing additional packages...$MODULES"
    apk add $MODULES
    rm -rf /var/cache/apk/*
  fi
}
