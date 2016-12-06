
# Alpine-SDK Build Dockerfile
# VERSION 3.4
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine:3.4
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="alpine-sdk"
LABEL VERSION="3.4"

USER root
RUN \
  apk update && \
  apk add python python-dev alpine-sdk util-linux autoconf automake && \
  rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/bash"]
