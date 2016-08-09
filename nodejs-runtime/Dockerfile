
# Nodejs-Runtime Dockerfile
# VERSION 6.2
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine:stable
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="nodejs-runtime"
LABEL VERSION="6.2"

USER root

# the directory to place the site files
ENV NODEJS_APPDIR   /data/nodejs

RUN \
  apk update && \
  apk add nodejs && \
  rm -rf /var/cache/apk/*

# add startup-script
ADD start_instance.sh /tmp/
ADD install_dependencies.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh && \
  chmod 755 /tmp/install_dependencies.sh

ONBUILD ADD ./dist     $NODEJS_APPDIR/
ONBUILD RUN /tmp/install_dependencies.sh

# Define working directory.
WORKDIR $NODEJS_APPDIR
