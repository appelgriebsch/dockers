#
# PostgreSQL Dockerfile
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos:latest
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# bind to localhost only (will expose a socket for connection)
ENV PGSQL_BIND		127.0.0.1
# default tcp port for postgresql server
ENV PGSQL_PORT		5432
# default path to the database files
ENV PGSQL_DBDIR		/data/pgsql
# default database user credentials <name:pwd>
ENV PGSQL_DBADMIN	pgAdmin:pgAdmin!
# default database for user
ENV PGSQL_DBNAME	sampleDB
# log level of postgresql server
ENV PGSQL_LOGLVL	notice

# install postgresql server
USER root
ADD ./start_instance.sh /
RUN \
  yum -y install http://yum.postgresql.org/9.3/redhat/rhel-7-x86_64/pgdg-centos93-9.3-1.noarch.rpm && \
  yum -y install nc postgresql93 postgresql93-contrib postgresql93-docs postgresql93-server postgresql93-plpython postgresql93-plruby && \  
  yum clean all && \
  mkdir -p /data/pgsql && \
  chown -R postgres:postgres /data/pgsql

# Define mountable directories.
VOLUME ["/data/pgsql"]

# Define working directory.
WORKDIR /data/pgsql

# Expose ports.
EXPOSE 5432

# run service
USER postgres
ENTRYPOINT ["/start_instance.sh"]
