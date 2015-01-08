#
# MySQL Dockerfile
# VERSION 5.6.20

# Pull CentOS 7 base image
FROM appelgriebsch/centos:latest
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>


# install MySQL server
USER root
## install mysql from mysql.org
RUN \
  yum -y install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm && \
  yum -y install mysql-community-server && \
  yum clean all && \
  mkdir -p /data/mysql && \
  chown -R mysql:mysql /data/mysql

# add startup-script
ADD ./start_instance.sh /
RUN \
  chmod 755 /start_instance.sh

# Define mountable directories.
VOLUME ["/data/mysql"]

# Define working directory.
WORKDIR /data/mysql

# Expose ports.
EXPOSE 3306

# run service
USER mysql
ENTRYPOINT ["/start_instance.sh"]
