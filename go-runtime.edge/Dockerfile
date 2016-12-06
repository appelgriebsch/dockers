
# Golang-Runtime Dockerfile
# VERSION 1.7
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine:edge
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="go-runtime"
LABEL VERSION="1.7"

USER root

# the directory to place the site files
ENV GO_APPDIR   /data/go

# add startup-script
COPY start_instance.sh /tmp/
COPY install_dependencies.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh && \
  chmod 755 /tmp/install_dependencies.sh

ONBUILD COPY ./dist     $GO_APPDIR/
ONBUILD RUN  /tmp/install_dependencies.sh
ONBUILD ENV  PATH       $GO_APPDIR:$PATH

# Define working directory.
WORKDIR $GO_APPDIR
