#
# MongoDB Dockerfile
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
# verbose log level of mongodb server
ENV MONGO_VERBOSE	0

# install mongodb
USER root
ADD mongodb.repo /etc/yum.repos.d/
ADD ./start_service.sh /tmp/
RUN \
  yum -y install mongodb-org && \
  yum clean all && \
  mkdir -p /data/mongodb && \  
  chown -R mongod:mongod /data/mongodb && \
  chmod -R 755 /data/mongodb && \ 
  sed -i "s/^\(logpath.*\)$/# \1/" /etc/mongod.conf && \
  sed -i "s/^\(fork.*\)$/# \1\nfork = false\ndirectoryperdb = true\nsmallfiles = true/" /etc/mongod.conf 

# Define mountable directories.
VOLUME ["/data/mongodb"]

# Define working directory.
WORKDIR /data/mongodb

# Expose ports.
EXPOSE 27017

# run service
USER mongod
ENTRYPOINT ["/tmp/start_service.sh"]
