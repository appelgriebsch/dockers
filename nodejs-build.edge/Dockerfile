
# Nodejs-Build Dockerfile
# VERSION 6.7
#

# Pull Alpine Linux edge base image
FROM appelgriebsch/alpine-sdk:edge
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="nodejs-build"
LABEL VERSION="6.9"

# build source environment variables
# ENV GIT_REPO    'github.com/appelgriebsch/dockers.git'
# ENV GIT_BRANCH  'master'
# ENV GIT_USER    'appelgriebsch'
# ENV GIT_TOKEN   '<github access token>'

# build arguments
ENV BUILD_ARGS    ''

# project release tar.gz bundling environment variables
ENV PROJ_NAME     'sample'
ENV PROJ_VER      '0.1.0'

USER root
RUN \
  apk update && \
  apk add nodejs nodejs-dev && \
  rm -rf /var/cache/apk/*

# add startup-script
COPY start_instance.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh

# Define mountable directories.
VOLUME /data/src

# Define working directory.
WORKDIR /data/src

# run build
ENTRYPOINT ["/tmp/start_instance.sh"]
