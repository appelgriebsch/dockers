#
# Redis Dockerfile
#

# Pull CentOS 7 base image
FROM centos:centos7

# update system
RUN \
  rpm -Uhv http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm && \
  yum -y update && \
  yum -y install mongodb mongodb-server && \
  sed -i 's/^\(dbpath.*\)$/# \1\ndbpath= \/data/' /etc/redis.conf

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# run service
CMD ["service", "mongod", "start"]

# Expose ports.
EXPOSE 27017
