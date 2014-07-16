#
# MongoDB Dockerfile
#

# Pull CentOS 7 base image
FROM centos:centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

ADD mongodb.repo /etc/yum.repos.d/

# update system
RUN \
  rpm -Uhv http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm && \
  yum -y update && \
  yum -y install mongodb-org && \
  sed -i 's/^\(bind_ip.*\)$/# \1/' /etc/mongod.conf && \
  sed -i 's/^\(dbpath.*\)$/# \1\ndbpath= \/data/' /etc/mongod.conf && \
  sed -i 's/^\(logpath.*\)$/# \1/' /etc/mongod.conf && \
  sed -i 's/^\(fork.*\)$/# \1\nfork = false\ndirectoryperdb = true\nsmallfiles = true/' /etc/mongod.conf 

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Expose ports.
EXPOSE 27017

# run service
ENTRYPOINT ["mongod", "-f", "/etc/mongod.conf"]
