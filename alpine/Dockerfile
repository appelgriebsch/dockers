#
# Alpine Linux 3.3 Dockerfile
#

# Pull Alpine 3.3 base image
FROM alpine:3.3
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="alpine-linux"
LABEL VERSION="3.3"

USER root

RUN apk update && apk upgrade && apk add bash curl && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/bash"]
