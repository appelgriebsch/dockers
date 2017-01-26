@echo off
REM package build specifics
set GO_NS=github.com/coreos/etcd
set PKG_NAME=etcd
set PKG_VER=3.1.0
set PKG_MAIN=main.go

REM Git repo settings
set GIT_REPO=github.com/coreos/etcd.git
set GIT_BRANCH=release-3.1

REM runtime specifics
set GO_VER=1.7
set PROXY=
set NO_PROXY=

if not exist %PKG_NAME%-%PKG_VER%-Release.tar.gz (
  docker run --rm -e GO_NS=%GO_NS% -e PROJ_NAME=%PKG_NAME% -e PROJ_VER=%PKG_VER% -e BUILD_ARGS=%PKG_MAIN% -e http_proxy=%PROXY% -e https_proxy=%PROXY% -e no_proxy=%NO_PROXY% -e GIT_REPO=%GIT_REPO% -e GIT_BRANCH=%GIT_BRANCH% -v %cd%:/data/build appelgriebsch/go-build:%GO_VER%
)

if exist %PKG_NAME%-%PKG_VER%-Release.tar.gz (
  echo Building Docker container...
  if not exist %cd%\dist (
    md %cd%\dist
  )
  if not exist %PKG_NAME%-%PKG_VER%-Release.tar (
    7z x -y %PKG_NAME%-%PKG_VER%-Release.tar.gz
  )
  7z x -o%cd%\dist -y %PKG_NAME%-%PKG_VER%-Release.tar
  docker build --build-arg http_proxy=%PROXY% --build-arg https_proxy=%PROXY% --build-arg no_proxy=%NO_PROXY% -t %PKG_NAME%:%PKG_VER% .
)
