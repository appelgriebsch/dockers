
# Alpine-SDK Build Dockerfile
# VERSION Edge
#

# Pull Alpine Linux edge base image
FROM appelgriebsch/alpine:edge
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="alpine-sdk"
LABEL VERSION="edge"

USER root
RUN \
  apk update && \
  apk add python python-dev alpine-sdk util-linux autoconf automake && \
  rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/bash"]
