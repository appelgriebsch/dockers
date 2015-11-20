#
# Alpine Linux 3.2 Dockerfile
#

# Pull Alpine 3.2 base image
FROM alpine:3.2
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="alpine-linux"
LABEL VERSION="3.2"

USER root

RUN apk update && apk upgrade && apk add bash && \
    rm -rf /var/cache/apk/*

ENTRYPOINT ["/bin/bash"]
