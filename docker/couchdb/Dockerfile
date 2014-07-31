#
# CouchDB Dockerfile
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos:latest
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# install CouchDB
USER root
ADD couchdb.ini /etc/supervisord.d/
RUN \
  yum -y install couchdb && \
  yum clean all && \
  mkdir -p /data && \
  mkdir -p /data/couchdb && \
  chown -R couchdb:couchdb /data/couchdb && \
  sed -i 's/^\(database_dir.*\)$/# \1\ndatabase_dir = \/data\/couchdb/' /etc/couchdb/default.ini && \
  sed -i 's/^\(view_index_dir.*\)$/# \1\nview_index_dir = \/data\/couchdb/' /etc/couchdb/default.ini && \
  sed -i 's/^\(bind_address.*\)$/# \1\nbind_address = 0.0.0.0/' /etc/couchdb/default.ini

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data/couchdb

# Expose ports.
EXPOSE 5984

# run service
ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf"]
