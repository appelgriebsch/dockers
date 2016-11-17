# Caddy Dockerfile
# VERSION 0.9
#

# Pull Alpine Linux stable base image
FROM appelgriebsch/alpine:3.4
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL AUTHOR="Andreas Gerlach <info@appelgriebsch.com>"
LABEL NAME="caddy-server"
LABEL VERSION="0.9"

# the directory to place the site files
ENV CADDY_SITEDIR   /data/caddy

# the network interface to bind to
ENV HOST            127.0.0.1

# the port to listen to
ENV PORT            8080

USER root
RUN \
    cd /tmp && \
    curl -L -o caddy_linux_amd64.tar.gz "https://caddyserver.com/download/build?os=linux&arch=amd64&features=git%2Cipfilter%2Cjwt%2Clocale%2Cminify%2Cprometheus%2Cratelimit%2Crealip" && \
    tar -xzf caddy_linux_amd64.tar.gz && \
    rm -rf /tmp/caddy_linux_amd64.tar.gz && \
    mkdir -p $CADDY_SITEDIR/site && \
    chown -R nobody:nobody $CADDY_SITEDIR

# add startup-script
ADD start_instance.sh /tmp/
RUN \
  chmod 755 /tmp/start_instance.sh

ONBUILD ADD Caddyfile  $CADDY_SITEDIR/

# Define Volume
VOLUME  $CADDY_SITEDIR/site

# Define working directory.
WORKDIR $CADDY_SITEDIR/site

# Expose ports.
EXPOSE  $PORT

# run service
USER nobody
ENTRYPOINT ["/tmp/start_instance.sh"]
