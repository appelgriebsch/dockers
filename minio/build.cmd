@echo off
# package build specifics
set GO_NS=github.com/minio/minio
set PKG_NAME=minio
set PKG_VER=0.1.0
set PKG_MAIN=main.go

# Git repo settings
set GIT_REPO=github.com/minio/minio.git
set GIT_BRANCH=release

# runtime specifics
set GO_VER=1.7
set PROXY=
set NO_PROXY=

if not exist %PKG_NAME%-%PKG_VER%-Release.tar.gz (
  docker run --rm -e GO_NS=%GO_NS% -e PROJ_NAME=%PKG_NAME% -e PROJ_VER=%PKG_VER% -e BUILD_ARGS=%PKG_MAIN% -e http_proxy=%PROXY% -e https_proxy=%PROXY% -e no_proxy=%NO_PROXY% -e GIT_REPO=%GIT_REPO% -e GIT_BRANCH=%GIT_BRANCH% -v %cd%:/data/build appelgriebsch/go-build:%GO_VER%
)

echo Building Docker container...
if exist %PKG_NAME%-%PKG_VER%-Release.tar.gz (
  md .\dist
  7z x %PKG_NAME%-%PKG_VER%-Release.tar.gz -o .\dist
  docker build --build-arg http_proxy=%PROXY% --build-arg https_proxy=%PROXY% --build-arg no_proxy=%NO_PROXY% -t %PKG_NAME%:%PKG_VER% .
)
