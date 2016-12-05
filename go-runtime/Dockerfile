
# Golang-Runtime Dockerfile
# VERSION 1.6
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine:3.4
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="go-runtime"
LABEL VERSION="1.6"

USER root

# the directory to place the site files
ENV GO_APPDIR   /data/go

# add startup-script
ADD start_instance.sh /tmp/
ADD install_dependencies.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh && \
  chmod 755 /tmp/install_dependencies.sh

ONBUILD ADD ./dist     $GO_APPDIR/
ONBUILD RUN /tmp/install_dependencies.sh
ONBUILD ENV PATH       $GO_APPDIR:$PATH

# Define working directory.
WORKDIR $GO_APPDIR
