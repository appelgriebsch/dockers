#
# Redis Dockerfile
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos:latest
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# install and configure redis
USER root
RUN \
  yum -y install redis && \
  yum clean all && \
  mkdir -p /data/redis/db && \
  chown -R redis:redis /data/redis && \
  chmod -R 755 /data/redis && \
  sed -i 's/^\(# unixsocket .*\)$/\1\nunixsocket \/data\/redis\/redis.sock/' /etc/redis.conf && \
  sed -i 's/^\(# unixsocketperm .*\)$/\1\nunixsocketperm 755/' /etc/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data\/redis\/db/' /etc/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis.conf

# Define mountable directories.
VOLUME ["/data/redis"]

# Define working directory.
WORKDIR /data/redis

# Expose ports.
EXPOSE 6379

# run service
USER redis
ENTRYPOINT ["/usr/bin/redis-server", "/etc/redis.conf"]
