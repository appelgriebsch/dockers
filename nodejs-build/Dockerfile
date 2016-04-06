
# Nodejs-Build Dockerfile
# VERSION 4.3.0
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine:stable
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="nodejs-build"
LABEL VERSION="4.3.0"

# build source environment variables
# ENV GIT_REPO    'github.com/appelgriebsch/dockers.git'
# ENV GIT_USER    'appelgriebsch'
# ENV GIT_TOKEN   '<github access token>'

# project release tar.gz bundling environment variables
ENV PROJ_NAME     'sample'
ENV PROJ_VER      '0.1.0'

USER root
RUN \
  apk update && \
  apk add nodejs nodejs-dev python python-dev alpine-sdk util-linux && \
  rm -rf /var/cache/apk/*

# add startup-script
ADD start_instance.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh

# Define mountable directories.
VOLUME /data/build

# Define working directory.
WORKDIR /data/build

# run build
ENTRYPOINT ["/tmp/start_instance.sh"]
