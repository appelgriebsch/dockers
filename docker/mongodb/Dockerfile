#
# MongoDB Dockerfile
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos:latest
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# install mongodb
USER root
ADD mongodb.repo /etc/yum.repos.d/
RUN \
  yum -y install mongodb-org && \
  yum clean all && \
  mkdir -p /data/mongodb/db && \  
  chown -R mongod:mongod /data/mongodb && \
  chmod -R 755 /data/mongodb && \ 
  sed -i 's/^\(dbpath.*\)$/# \1\ndbpath= \/data\/mongodb\/db/' /etc/mongod.conf && \
  sed -i 's/^\(logpath.*\)$/# \1/' /etc/mongod.conf && \
  sed -i 's/^\(fork.*\)$/# \1\nfork = false\ndirectoryperdb = true\nsmallfiles = true\nunixSocketPrefix=\/data\/mongodb\//' /etc/mongod.conf 

# Define mountable directories.
VOLUME ["/data/mongodb"]

# Define working directory.
WORKDIR /data/mongodb

# Expose ports.
EXPOSE 27017

# run service
USER mongod
ENTRYPOINT ["/usr/bin/mongod", "-f", "/etc/mongod.conf"]
