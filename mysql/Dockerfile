#
# MySQL Dockerfile
# VERSION 5.6.24

# Pull CentOS 7 base image
FROM appelgriebsch/centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL VERSION="5.6.24"

# bind to localhost only (will expose a socket for connection)
ENV MYSQL_BIND	  127.0.0.1
# default tcp port for postgresql server
ENV MYSQL_PORT		3306
# default path to the database files
ENV MYSQL_DBDIR		/data/mysql
# default database user credentials <name:pwd> (name is lowercase)
ENV MYSQL_DBADMIN admin:Admin123!
# default database for user (dbname is lowercase)
ENV MYSQL_DBNAME	sampledb
# log level of mysql server
ENV MYSQL_LOGLVL	notice

# install MySQL server
USER root
## install mysql from mysql.org
RUN \
  yum -y install http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm && \
  yum -y install mysql-community-server mysql-community-client && \
  yum clean all && \
  mkdir -p $MYSQL_DBDIR && \
  chown -R mysql:mysql $MYSQL_DBDIR && \
  chmod -R 755 $MYSQL_DBDIR

# add startup-script
ADD ./start_instance.sh /
RUN \
  chmod 755 /start_instance.sh

# Define mountable directories.
VOLUME $MYSQL_DBDIR

# Define working directory.
WORKDIR $MYSQL_DBDIR

# Expose ports.
EXPOSE $MYSQL_PORT

# run service
USER mysql
ENTRYPOINT ["/start_instance.sh"]
