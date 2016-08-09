
# Golang-Runtime Dockerfile
# VERSION 1.6
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine:stable
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="golang-runtime"
LABEL VERSION="1.6"

USER root

# the directory to place the site files
ENV GOLANG_APPDIR   /data/golang

# add startup-script
ADD start_instance.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh

ONBUILD ADD ./dist     $GOLANG_APPDIR/

# Define working directory.
WORKDIR $GOLANG_APPDIR

# run build
USER nobody
ENTRYPOINT ["/tmp/start_instance.sh"]
