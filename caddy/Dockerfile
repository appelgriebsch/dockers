# Caddy Dockerfile
# VERSION 0.8.2
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine:stable
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="caddy-server"
LABEL VERSION="0.8.2"

# the directory to place the site files
ENV CADDY_SITEDIR   /data/caddy

USER root
RUN \
    cd /tmp && \
    curl -L -o caddy_linux_amd64.tar.gz "https://caddyserver.com/download/build?os=linux&arch=amd64&features=cors%2Cipfilter%2Cjsonp" && \
    tar -xzf caddy_linux_amd64.tar.gz && \
    rm -rf /tmp/caddy_linux_amd64.tar.gz && \
    mkdir -p $CADDY_SITEDIR && \
    chown -R nobody:nobody $CADDY_SITEDIR

# add startup-script
ADD start_instance.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh

ONBUILD ADD Caddyfile  $CADDY_SITEDIR/
ONBUILD ADD ./dist     $CADDY_SITEDIR/

# Define working directory.
WORKDIR $CADDY_SITEDIR

# run service
USER nobody
ENTRYPOINT ["/tmp/start_instance.sh"]
