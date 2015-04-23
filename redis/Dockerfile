#
# Redis Dockerfile
# VERSION 2.8.13
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos:latest
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# bind to localhost only (will expose a socket for connection)
ENV REDIS_BIND		127.0.0.1
# default tcp port for redis server
ENV REDIS_PORT 		6379
# default no. of databases
ENV REDIS_DBCNT		16
# name of the database dump file
ENV REDIS_DBFILE 	redis_01.rdb
# if master is set, this node is a slave to this master (ip:port)
# ENV REDIS_MASTER
# if dbpwd is set, security check is implied
# ENV REDIS_DBPWD
# log level of redis server
ENV REDIS_LOGLVL	notice

# install and configure redis
USER root
RUN \
  yum -y install redis && \
  yum clean all && \
  mkdir -p /data/redis && \
  chown -R redis:redis /data/redis && \
  sed -i "s/^\(daemonize .*\)$/# \1/" /etc/redis.conf && \
  sed -i "s/^\(logfile .*\)$/# \1/" /etc/redis.conf

# add startup-script
ADD ./start_instance.sh /
RUN \
  chmod 755 /start_instance.sh

# Define mountable directories.
VOLUME ["/data/redis"]

# Define working directory.
WORKDIR /data/redis

# Expose ports.
EXPOSE 6379

# run service
USER redis
ENTRYPOINT ["/start_instance.sh"]
