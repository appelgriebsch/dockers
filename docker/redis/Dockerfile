#
# Redis Dockerfile
#

# Pull CentOS 7 base image
FROM centos:centos7

# update system
RUN \
  rpm -Uhv http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.2.noarch.rpm && \
  yum -y update && \
  yum -y install redis && \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis.conf

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Define default command.
CMD ["/usr/sbin/redis-server", "/etc/redis.conf"]

# Expose ports.
EXPOSE 6379
