#
# PostgreSQL Dockerfile
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos7
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# install postgresql server
USER root
RUN \
  rpm -Uhv http://yum.postgresql.org/9.3/redhat/rhel-7-x86_64/pgdg-centos93-9.3-1.noarch.rpm && \
  yum -y install postgresql93 postgresql93-contrib postgresql93-docs postgresql93-server postgresql93-plpython postgresql93-plruby && \
  mkdir -p /data && \
  mkdir -p /data/postgresql && \
  chown -R postgres:postgres /data/postgresql

# add supervisor configuration
ADD postgresql.ini /etc/supervisord.d/
ADD initDB.sh /tmp/

# init the database
USER postgres
RUN \
   /tmp/initDB.sh

# set up autostart of service, mountable data points 
USER root

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

# Expose ports.
EXPOSE 5432

# run service
ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf"]
