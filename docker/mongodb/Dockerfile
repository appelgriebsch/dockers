#
# MongoDB Dockerfile
# VERSION 2.6.4
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos:latest
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# bind to localhost only (will expose a socket for connection)
ENV MONGO_BIND		127.0.0.1
# default tcp port for mongo server
ENV MONGO_PORT 		27017
# default path to the database files
ENV MONGO_DBDIR		/data/mongodb
# verbose log level of mongodb server (0-5)
ENV MONGO_LOGLVL	0
# mode of node (e.g. normal, arbiter, config, shard)
ENV MONGO_TYPE		normal
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
  mkdir -p /data/mongodb && \  
  chown -R mongod:mongod /data/mongodb && \
  chmod -R 755 /data/mongodb && \ 
  echo "# new YAML based config file for mongodb > 2.6" > /etc/mongod.conf && \
  echo "processManagement.fork: false" >> /etc/mongod.conf && \
  echo "systemLog.verbosity: 0" >> /etc/mongod.conf && \
  echo "net.bindIp: 127.0.0.1" >> /etc/mongod.conf && \
  echo "net.port: 27017" >> /etc/mongod.conf && \
  echo "storage.dbPath: /data/mongodb" >> /etc/mongod.conf && \
  echo "storage.directoryPerDB: true" >> /etc/mongod.conf && \
  echo "storage.smallFiles: true" >> /etc/mongod.conf && \
  echo "storage.journal.enabled: true" >> /etc/mongod.conf
 
# add startup-script
ADD ./start_instance.sh /
RUN \
  chmod 755 /start_instance.sh

# Define mountable directories.
VOLUME ["/data/mongodb"]

# Define working directory.
WORKDIR /data/mongodb

# Expose ports (mongodb - 27017, config-srv - 27018, shard-srv - 27019)
EXPOSE 27017

# run service
USER mongod
ENTRYPOINT ["/start_instance.sh"]
