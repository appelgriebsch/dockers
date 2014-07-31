#
# Node.js Dockerfile
#

# Pull CentOS 7 base image
FROM appelgriebsch/centos:latest
MAINTAINER Andreas Gerlach <info@appelgriebsch.com>

# install nodejs version management system
USER root
RUN \
  yum -y install nodejs npm nodejs-devel && \
  yum clean all && \
  mkdir -p /data && \
  mkdir -p /data/nodejs && \
  npm install -g bower browserify gulp && \
  npm cache clean

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data/nodejs
