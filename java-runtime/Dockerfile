
# Java-Runtime Dockerfile
# VERSION 1.8
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine:stable
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="java-runtime"
LABEL VERSION="1.8"

USER root

# the directory to place the site files
ENV JAVA_APPDIR   /data/java

RUN \
  apk update && \
  apk add openjdk8-jre && \
  rm -rf /var/cache/apk/*

# add startup-script
ADD start_instance.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh

ONBUILD ADD ./dist     $JAVA_APPDIR/

# Define working directory.
WORKDIR $JAVA_APPDIR

# run build
USER nobody
ENTRYPOINT ["/tmp/start_instance.sh"]
