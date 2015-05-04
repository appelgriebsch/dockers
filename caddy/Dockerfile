#
# Caddy Dockerfile
# VERSION 0.5.1
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL VERSION="0.5.1"

# the version no of CADDY
ENV CADDY_VERSION   0.5.1

# the directory to place the site files
ENV CADDY_SITEDIR   /data/caddy

USER root
RUN \
    yum install -y unzip && \
    yum clean all && \
    cd /tmp && \
    curl -L -O https://github.com/mholt/caddy/releases/download/v$CADDY_VERSION/caddy_linux_amd64.zip && \
    unzip caddy_linux_amd64.zip && \
    ln -sfv caddy_linux_amd64 caddy && \
    chmod 755 /tmp/caddy* && \
    rm -rf /tmp/caddy_linux_amd64.zip && \
    setcap cap_net_bind_service=+ep /tmp/caddy_linux_amd64 && \
    mkdir -p $CADDY_SITEDIR && \
    chown -R nobody:nobody $CADDY_SITEDIR

# add startup-script
ADD ./start_instance.sh /
RUN \
  chmod 755 /start_instance.sh

ONBUILD ADD Caddyfile  $CADDY_SITEDIR/
ONBUILD ADD ./dist     $CADDY_SITEDIR/

# Define working directory.
WORKDIR $CADDY_SITEDIR

# run service
USER nobody
ENTRYPOINT ["/start_instance.sh"]
