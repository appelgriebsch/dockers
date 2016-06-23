
# Nodejs-Runtime Dockerfile
# VERSION 6.2.0
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine:stable
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="nodejs-runtime"
LABEL VERSION="6.2.0"

USER root

# the directory to place the site files
ENV NODEJS_APPDIR   /data/nodejs

RUN \
  apk update && \
  apk add nodejs && \
  rm -rf /var/cache/apk/*

# add startup-script
ADD start_instance.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh

ONBUILD ADD ./dist     $NODEJS_APPDIR/

# Define working directory.
WORKDIR $NODEJS_APPDIR

# run build
USER nobody
ENTRYPOINT ["/tmp/start_instance.sh"]
