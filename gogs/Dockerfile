#
# Gogs Dockerfile
# VERSION 0.6.1
#

# Pull CentOS 6 base image
FROM appelgriebsch/centos6
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>
LABEL VERSION="0.6.1"

# bind to localhost only (will expose a socket for connection)
ENV GOGS_BIND		  127.0.0.1
# default tcp port for gogs server
ENV GOGS_PORT 	  6000
# verbose log level of gogs server
ENV GOGS_LOGLVL	  Warn
# directory hosting the repositories
ENV GOGS_REPDIR   /data/gogs
# database type for gogs
ENV GOGS_DBTYPE   sqlite3
# database host (host:port)
ENV GOGS_DBHOST   localhost
# database user information (name:pwd)
# ENV GOGS_DBUSR  ''
# database name
ENV GOGS_DBNAME   gogs.db
# secret key to keep user data safe (has to set from cmd line when running container!)
ENV GOGS_SECRET   !Gogs_SeCReT_KeY!

# install server and configure it
USER root
ADD gogs.repo /etc/yum.repos.d/

## install gogs
RUN \
  rpm --import https://rpm.packager.io/key && \
  yum install -y gogs && \
  yum clean all && \
  mkdir -p $GOGS_REPDIR && \
  chown -R gogs:gogs $GOGS_REPDIR && \
  chmod -R 755 $GOGS_REPDIR && \
  mkdir -p /opt/gogs/custom/conf && \
  rm -rf /opt/gogs/custom/conf/app.ini && \
  echo "# custom gogs configuration" > /opt/gogs/custom/conf/app.ini && \
  echo "APP_NAME = Gogs - Self-hosted Git repositories" >> /opt/gogs/custom/conf/app.ini && \
  echo "RUN_MODE = prod"  >> /opt/gogs/custom/conf/app.ini && \
  echo "[repository]"   >> /opt/gogs/custom/conf/app.ini && \
  echo "ROOT = $GOGS_REPDIR"  >> /opt/gogs/custom/conf/app.ini && \
  echo "[server]" >> /opt/gogs/custom/conf/app.ini && \
  echo "HTTP_ADDR = $GOGS_BIND" >> /opt/gogs/custom/conf/app.ini && \
  echo "HTTP_PORT = $GOGS_PORT" >> /opt/gogs/custom/conf/app.ini && \
  echo "ENABLE_GZIP = true"   >> /opt/gogs/custom/conf/app.ini && \
  echo "[database]"   >> /opt/gogs/custom/conf/app.ini && \
  echo "DB_TYPE = $GOGS_DBTYPE"   >> /opt/gogs/custom/conf/app.ini && \
  echo "HOST = $GOGS_DBHOST"    >> /opt/gogs/custom/conf/app.ini && \
  echo "NAME = $GOGS_DBNAME"  >> /opt/gogs/custom/conf/app.ini && \
  echo "PATH = $GOGS_DBNAME"  >> /opt/gogs/custom/conf/app.ini && \
  echo "[security]"   >> /opt/gogs/custom/conf/app.ini && \
  echo "SECRET_KEY = $GOGS_SECRET"  >> /opt/gogs/custom/conf/app.ini && \
  echo "[log]"    >> /opt/gogs/custom/conf/app.ini && \
  echo "MODE = console" >> /opt/gogs/custom/conf/app.ini && \
  echo "LEVEL = $GOGS_LOGLVL"   >> /opt/gogs/custom/conf/app.ini && \
  chown gogs:gogs /opt/gogs/custom/conf/app.ini

# add startup-script
ADD ./start_instance.sh /
RUN \
  chmod 755 /start_instance.sh

# Define mountable directories.
VOLUME $GOGS_REPDIR

# Define working directory.
WORKDIR $GOGS_REPDIR

# Expose ports
EXPOSE $GOGS_PORT

# run service
USER gogs
ENTRYPOINT ["/start_instance.sh"]
