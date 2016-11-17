
# Golang-Build Dockerfile
# VERSION 1.7
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine:edge
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="golang-build"
LABEL VERSION="1.7"

# build source environment variables
# ENV GIT_REPO    'github.com/appelgriebsch/dockers.git'
# ENV GIT_USER    'appelgriebsch'
# ENV GIT_TOKEN   '<github access token>'

# build arguments
ENV BUILD_ARGS    ''

# project release tar.gz bundling environment variables
ENV PROJ_NAME     'sample'
ENV PROJ_VER      '0.1.0'
ENV PROJ_NS       'com.appelgriebsch.sample'

USER root
RUN \
  apk update && \
  apk add go go-tools python python-dev alpine-sdk util-linux && \
  rm -rf /var/cache/apk/*

# add startup-script
ADD start_instance.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh

# Define mountable directories.
VOLUME /data/src

# Define working directory.
WORKDIR /data/src

# run build
ENTRYPOINT ["/tmp/start_instance.sh"]
