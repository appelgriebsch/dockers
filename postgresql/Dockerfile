#
# PostgreSQL Dockerfile
# VERSION 9.4.1

# Pull CentOS 7 base image
FROM appelgriebsch/centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL VERSION="9.4.1"

# bind to localhost only (will expose a socket for connection)
ENV PGSQL_BIND	  127.0.0.1
# netmask for localhost only binding (specifies the network segment the server listen to)
ENV PGSQL_NETMASK	127.0.0.1/8
# default tcp port for postgresql server
ENV PGSQL_PORT		5432
# default path to the database files
ENV PGSQL_DBDIR		/data/pgsql
# default database user credentials <name:pwd> (name is lowercase)
ENV PGSQL_DBADMIN pgadmin:pgAdmin123!
# default database for user (dbname is lowercase)
ENV PGSQL_DBNAME	sampledb
# log level of postgresql server
ENV PGSQL_LOGLVL	notice
# Version information
ENV PG_VERSION    9.4

# install postgresql server
USER root
RUN \
  yum -y install http://yum.postgresql.org/$PG_VERSION/redhat/rhel-6-x86_64/pgdg-redhat94-9.4-1.noarch.rpm  && \
  yum -y install nc postgresql94 postgresql94-contrib postgresql94-docs postgresql94-server postgresql94-plpython && \
  yum clean all && \
  mkdir -p /data/pgsql && \
  chown -R postgres:postgres /data/pgsql

# add startup-script
ADD ./start_instance.sh /
RUN \
  chmod 755 /start_instance.sh

# Define mountable directories.
VOLUME ["/data/pgsql"]

# Define working directory.
WORKDIR /data/pgsql

# Expose ports.
EXPOSE 5432

# run service
USER postgres
ENTRYPOINT ["/start_instance.sh"]
