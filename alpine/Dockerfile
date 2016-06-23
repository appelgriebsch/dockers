#
# Alpine Linux 3.4 Dockerfile
#

# Pull Alpine 3.4 base image
FROM alpine:3.4
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="alpine-linux"
LABEL VERSION="3.4"

USER root

RUN apk update && apk upgrade && apk add bash curl && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/bash"]
