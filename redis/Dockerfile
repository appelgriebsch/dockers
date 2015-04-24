#
# Redis Dockerfile
# VERSION 3.0.0
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL VERSION="3.0.0"

# bind to localhost only (will expose a socket for connection)
ENV REDIS_BIND		127.0.0.1
# default tcp port for redis server
ENV REDIS_PORT 		6379
# default no. of databases
ENV REDIS_DBCNT		16
# default database directory
ENV REDIS_DBDIR /data/redis
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
  yum install -y tar make gcc && \
  yum clean all && \
  cd /tmp && \
  curl -O http://download.redis.io/releases/redis-3.0.0.tar.gz && \
  tar -xzf redis-3.0.0.tar.gz && \
  cd redis-3.0.0 && \
  make PREFIX=/usr && make PREFIX=/usr install && \
  cp redis.conf /etc && \
  cd / && rm -rf /tmp/redis* && \
  yum remove -y tar make gcc glibc-headers glibc-devel cpp kernel-plus-headers libmpc mpfr && \
  yum clean all && \
  adduser -b $REDIS_DBDIR -r redis && \
  mkdir -p $REDIS_DBDIR && \
  chown -R redis:redis $REDIS_DBDIR && \
  chmod -R 755 $REDIS_DBDIR && \
  sed -i "s/^\(daemonize .*\)$/# \1/" /etc/redis.conf && \
  sed -i "s/^\(logfile .*\)$/# \1/" /etc/redis.conf

# add startup-script
ADD ./start_instance.sh /
RUN \
  chmod 755 /start_instance.sh

# Define mountable directories.
VOLUME $REDIS_DBDIR

# Define working directory.
WORKDIR $REDIS_DBDIR

# Expose ports.
EXPOSE $REDIS_PORT

# run service
USER redis
ENTRYPOINT ["/start_instance.sh"]
