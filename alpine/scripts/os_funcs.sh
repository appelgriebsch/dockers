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
