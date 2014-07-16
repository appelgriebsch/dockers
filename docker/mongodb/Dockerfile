#
# MongoDB Dockerfile
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# install mongodb
USER root
ADD mongodb.repo /etc/yum.repos.d/
ADD mongod.ini /etc/supervisord.d/
RUN \
  yum -y install mongodb-org && \
  mkdir -p /data && \
  mkdir -p /data/mongodb && \
  chown -R mongod:mongod /data/mongodb && \
  sed -i 's/^\(bind_ip.*\)$/# \1/' /etc/mongod.conf && \
  sed -i 's/^\(dbpath.*\)$/# \1\ndbpath= \/data\/mongodb/' /etc/mongod.conf && \
  sed -i 's/^\(logpath.*\)$/# \1/' /etc/mongod.conf && \
  sed -i 's/^\(fork.*\)$/# \1\nfork = false\ndirectoryperdb = true\nsmallfiles = true/' /etc/mongod.conf 

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data/mongodb

# Expose ports.
EXPOSE 27017

# run service
ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf"]
