
# Nodejs-Runtime Dockerfile
# VERSION 6.7
#

# Pull Alpine Linux edge base image
FROM appelgriebsch/alpine:edge
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="nodejs-runtime"
LABEL VERSION="6.9"

USER root

# the directory to place the site files
ENV NODEJS_APPDIR   /data/nodejs

RUN \
  apk update && \
  apk add nodejs && \
  rm -rf /var/cache/apk/*

# add startup-script
COPY start_instance.sh /tmp/
COPY install_dependencies.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh && \
  chmod 755 /tmp/install_dependencies.sh

ONBUILD COPY ./dist     $NODEJS_APPDIR/
ONBUILD RUN  /tmp/install_dependencies.sh
ONBUILD ENV  PATH       $NODEJS_APPDIR/bin:$PATH

# Define working directory.
WORKDIR $NODEJS_APPDIR
