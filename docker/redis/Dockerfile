#
# Redis Dockerfile
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# install and configure redis
USER root
RUN \
  yum -y install redis && \
  mkdir -p /data && \
  mkdir -p /data/redis && \
  mkdir -p /data/redis/db && \
  chown -R redis:redis /data/redis && \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data\/redis\/db/' /etc/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis.conf

# add supervisor configuration
ADD redis-server.ini /etc/supervisord.d/

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data/redis

# Expose ports.
EXPOSE 6379

# run service
ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf"]
