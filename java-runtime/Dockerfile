
# Java-Runtime Dockerfile
# VERSION 1.8
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine:3.4
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
ADD install_dependencies.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh && \
  chmod 755 /tmp/install_dependencies.sh

ONBUILD ADD ./dist     $JAVA_APPDIR/
ONBUILD RUN /tmp/install_dependencies.sh
ONBUILD ENV PATH       $JAVA_APPDIR:$PATH

# Define working directory.
WORKDIR $JAVA_APPDIR
