#
# MongoDB Dockerfile
# VERSION 3.0.2
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL VERSION="3.0.2"

# bind to localhost only (will expose a socket for connection)
ENV MONGO_BIND		127.0.0.1
# default tcp port for mongo server
ENV MONGO_PORT 		27017
# verbose log level of mongodb server (0-5)
ENV MONGO_LOGLVL	0
# mode of node (e.g. normal, arbiter, config, shard)
ENV MONGO_TYPE		normal
# default mongodb directory
ENV MONGO_DBDIR /data/mongodb
# name of replica set (if available)
# ENV MONGO_REPLSET
# address of master server (ip:port)
# ENV MONGO_MASTER
# address of config server (ip:port)
# ENV MONGO_CONFIG

# install mongodb and create a default YAML config file
USER root
ADD mongodb.repo /etc/yum.repos.d/

## install mongodb from 10gen
RUN \
  yum -y install nc mongodb-org && \
  yum clean all && \
  mkdir -p $MONGO_DBDIR && \
  chown -R mongod:mongod $MONGO_DBDIR && \
  chmod -R 755 $MONGO_DBDIR && \
  echo "# new YAML based config file for mongodb > 2.6" > /etc/mongod.conf && \
  echo "processManagement.fork: false" >> /etc/mongod.conf && \
  echo "systemLog.verbosity: 0" >> /etc/mongod.conf && \
  echo "net.bindIp: 127.0.0.1" >> /etc/mongod.conf && \
  echo "net.port: 27017" >> /etc/mongod.conf && \
  echo "storage.dbPath: /data/mongodb" >> /etc/mongod.conf && \
  echo "storage.directoryPerDB: true" >> /etc/mongod.conf && \
  echo "storage.mmapv1.smallFiles: true" >> /etc/mongod.conf && \
  echo "storage.journal.enabled: true" >> /etc/mongod.conf

# add startup-script
ADD ./start_instance.sh /
RUN \
  chmod 755 /start_instance.sh

# Define mountable directories.
VOLUME $MONGO_DBDIR

# Define working directory.
WORKDIR $MONGO_DBDIR

# Expose ports (mongodb - 27017, config-srv - 27018, shard-srv - 27019)
EXPOSE $MONGO_PORT

# run service
USER mongod
ENTRYPOINT ["/start_instance.sh"]
