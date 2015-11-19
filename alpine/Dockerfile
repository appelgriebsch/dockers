#
# Alpine Linux 3.2 Dockerfile
#

# Pull Alpine edge base image
FROM alpine:3.2
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL VERSION="3.2"

USER root

RUN apk update && apk upgrade && apk add bash && \
    rm -rf /var/cache/apk/*
