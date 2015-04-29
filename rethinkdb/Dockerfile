#
# RethinkDB Dockerfile
# VERSION 2.0.1
#

# Pull CentOS 6 base image
FROM appelgriebsch/centos6
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL VERSION="2.0.1"

# bind to localhost only (will expose a socket for connection)
ENV RTDB_BIND		127.0.0.1
# default tcp port for rethinkdb server
ENV RTDB_PORT 	28015
# verbose log level of rethinkdb server (0-5)
ENV RTDB_LOGLVL	0
# default path to the database files
ENV RTDB_DBDIR	/data/rethinkdb
# address of master server (ip:port)
# ENV RTDB_MASTER

# install rethinkdb and create a default config file
USER root
ADD rethinkdb.repo /etc/yum.repos.d/
RUN \
  yum -y install nc rethinkdb && \
  yum clean all && \
  mkdir -p $RTDB_DBDIR && \
  chown -R rethinkdb:rethinkdb $RTDB_DBDIR && \
  chmod -R 755 $RTDB_DBDIR && \
  sed -i "s/^\(# runuser.*\)$/# \1\nrunuser=rethinkdb/" /etc/rethinkdb/default.conf.sample && \
  sed -i "s/^\(# rungroup.*\)$/# \1\nrungroup=rethinkdb/" /etc/rethinkdb/default.conf.sample && \
  sed -i "s/^\(# directory.*\)$/# \1\ndirectory=\/data\/rethinkdb/" /etc/rethinkdb/default.conf.sample

# add startup-script
ADD ./start_instance.sh /
RUN \
  chmod 755 /start_instance.sh

# Define mountable directories.
VOLUME $RTDB_DBDIR

# Define working directory.
WORKDIR $RTDB_DBDIR

# Expose ports
EXPOSE $RTDB_PORT

# run service
USER rethinkdb
ENTRYPOINT ["/start_instance.sh"]
